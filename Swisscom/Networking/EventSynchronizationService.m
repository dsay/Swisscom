#import "EventSynchronizationService.h"

#import <Reachability/Reachability.h>
#import "DataStorage.h"

#import "Singleton.h"
#import "ApiClient.h"

#import "ApiClient+Result.h"

@interface EventSynchronizationService ()

@property (strong) Reachability *reachability;
@property (atomic, assign) BOOL is_progress;
@property (atomic, assign) BOOL is_need_sync;

@end

@implementation EventSynchronizationService

SYNTHESIZE_SINGLETON_FOR_CLASS(EventSynchronizationService)

- (void)dealloc
{
	[self.reachability stopNotifier];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)contextDidSave:(NSNotification *)notification
{
    [self startSync];
}

- (void)changeReachabilityState:(NSNotification *)notification
{
	[self startSync];
}

- (void)stopSync
{
	self.is_need_sync = NO;
    
	[self.apiClient.manager.operationQueue cancelAllOperations];
	[self.reachability stopNotifier];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)beginSyncing
{
    NSParameterAssert([[DataStorage shared].contextProvider mainContext]);

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextDidSave:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:[[DataStorage shared].contextProvider mainContext]];
    
	self.reachability = [Reachability reachabilityForInternetConnection];
	[[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(changeReachabilityState:)
                                                name:kReachabilityChangedNotification
                                              object:nil];
	[self.reachability startNotifier];
	[self startSync];
}

- (void)startSync
{
	NSParameterAssert([NSThread isMainThread]);
    
	if([self.reachability currentReachabilityStatus] == NotReachable)
		return;
    
	static NSInteger count;
    
	if (count > 0 || self.is_progress == YES) {
		self.is_need_sync = YES;
		return;
	}
    
	self.is_progress = YES;
	self.is_need_sync = NO;
    
	void (^ProcessingBlock)(NSInteger ) = ^(NSInteger index){
		dispatch_barrier_async(dispatch_get_main_queue(), ^{
            count += index;
            
            if (count <= 0) {
                self.is_progress = NO;
                count = 0;
                
                if (self.is_need_sync)
                    [self startSync];
            }
        });
	};
    
    [self syncReportsProcessingBlock:ProcessingBlock];
}

- (void)syncReportsProcessingBlock:(void (^)(NSInteger))ProcessingBlock
{
    NSManagedObjectContext *context = [[DataStorage shared].contextProvider createTemporaryContext];
    
    ProcessingBlock(+1);
    [context performBlock:^{
        NSError *error;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SWResultTimingEvent"];
        NSArray *reportTimingEvents = [context executeFetchRequest:request error:&error];
        NSAssert(error == nil, @"Cannot fetch events for syncing: %@",error);
        
        NSArray *results = [reportTimingEvents valueForKey:@"result"];
        NSArray *IDs = [reportTimingEvents valueForKey:@"objectID"];
        if (results.count > 0)
        {
            ProcessingBlock(+1);
            [self.apiClient uploadResults:results completion:^(NSDictionary *dict, NSString *error) {
                if (dict && !error)
                {
                    [context performBlock:^{
                        for (NSManagedObjectID *objectId in IDs)
                        {
                            NSManagedObject *report = [context objectWithID:objectId];
                            [context deleteObject:report];
                        }
                        NSError *error;
                        [context save:&error];
                        
                        ProcessingBlock(-1);
                    }];
                }
                else ProcessingBlock(-1);
            }];
        }
        ProcessingBlock(-1);
    }];
}

@end

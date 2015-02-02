#import "EventSynchronizationService.h"

#import <Reachability/Reachability.h>
#import "DataStorage.h"

#import "Singleton.h"
#import "ApiClient.h"

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
    
}

//- (void)syncReportsProcessingBlock:(void (^)(NSInteger))ProcessingBlock
//{
//    NSManagedObjectContext *context = [[BBDataStorage shared].contextProvider createTemporaryContext];
//
//    ProcessingBlock(+1);
//    [context performBlock:^{
//        NSError *error;
//        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ReportTimingEvent"];
//        NSArray *reportTimingEvents = [context executeFetchRequest:request error:&error];
//        NSAssert(error == nil, @"Cannot fetch events for syncing: %@",error);
//        
//        for (NSManagedObject *report in reportTimingEvents)
//        {
//            NSManagedObjectID *objectID = report.objectID;
//            
//            NSDictionary *params = [report valueForKey:@"reportParameters"];
//            [[BabylonApp2ApiClient shared]POST:@"mobile/triage/result/symptom/create"
//                           parameters:params
//            constructingBodyWithBlock:nil
//                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                 if (operation.response.statusCode == 200)
//                                 {
//                                     [context performBlock:^{
//                                         NSManagedObject *report = [context objectWithID:objectID];
//                                         [context deleteObject:report];
//                                         
//                                         NSError *error;
//                                         [context save:&error];
//                                         
//                                         ProcessingBlock(-1);
//                                     }];
//                                 }
//                                 else
//                                 {
//                                     ProcessingBlock(-1);
//                                 }
//                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                 ProcessingBlock(-1);
//                             }];
//            ProcessingBlock(+1);
//        }
//        ProcessingBlock(-1);
//    }];
//}

@end

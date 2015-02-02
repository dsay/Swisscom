#import "SynchronizationService.h"

#import "Singleton.h"
#import "ApiClient+Question.h"
#import "DataStorage.h"
#import "QuestionsMapper.h"

static NSString * const kIsUpdated = @"Updated";

@interface SynchronizationService()
{
    BOOL _isUpdating;
}
@property (atomic, copy) success success;

@end

@implementation SynchronizationService

SYNTHESIZE_SINGLETON_FOR_CLASS(SynchronizationService)

- (void)startSynchronizationSuccess:(void (^)(BOOL))success
{
    if (!_isUpdating && ![self isUpdated])
    {
        _isUpdating = YES;
        self.success = success;
        [self.apiClient questionsCompletion:^(NSDictionary *dict, NSString *error) {
            if (dict && !error)
            {
                [self fetchData:dict];
            }
            else
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.success(NO);
                });
        }];
    }
}

- (void)fetchData:(NSDictionary *)data
{
    NSManagedObjectContext *context = [[DataStorage shared].contextProvider createTemporaryContext];
    [context performBlock:^{
        
        [QuestionsMapper importQuestionsData:data toContext:context];
        
        NSError *error;
        [context save:&error];
        NSAssert(error == nil, @"Save export Context : %@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
            {
                self.success(NO);
#if DEBUG
                NSLog(@"Error saving context. %@", error);
#endif
            }
            else
            {
                self.success(YES);
                [self setIsUpdated];
            }
        });
    }];
}

- (void)setIsUpdated
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUpdated];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isUpdated
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsUpdated];
}

@end

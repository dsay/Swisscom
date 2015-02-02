#import "SynchronizationService.h"
#import "Singleton.h"

@interface SynchronizationService()

@end

@implementation SynchronizationService

SYNTHESIZE_SINGLETON_FOR_CLASS(SynchronizationService)

- (void)startSynchronizationSuccess:(void (^)(BOOL))success
{
    
}

@end

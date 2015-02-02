#import <Foundation/Foundation.h>
#import "ApiClient.h"

@interface SynchronizationService : NSObject

@property (nonatomic, strong) ApiClient *apiClient;

+ (SynchronizationService *)shared;
- (void )startSynchronizationSuccess:(void(^)(BOOL success))success;

@end

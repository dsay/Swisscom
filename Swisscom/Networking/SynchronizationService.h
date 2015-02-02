#import <Foundation/Foundation.h>
#import "ApiClient.h"

typedef void (^success)(BOOL);
@interface SynchronizationService : NSObject

@property (nonatomic, strong) ApiClient *apiClient;

+ (SynchronizationService *)shared;
- (void )startSynchronizationSuccess:(success)success;

@end

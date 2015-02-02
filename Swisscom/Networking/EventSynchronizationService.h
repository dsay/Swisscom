#import <Foundation/Foundation.h>
#import "ApiClient.h"

@interface EventSynchronizationService : NSObject

@property (nonatomic, strong) ApiClient *apiClient;

+(EventSynchronizationService *)shared;

- (void)beginSyncing;
- (void)stopSync;

@end

#import <Foundation/Foundation.h>

@interface EventSynchronizationService : NSObject

+(EventSynchronizationService *)shared;

- (void)beginSyncing;
- (void)stopSync;

@end

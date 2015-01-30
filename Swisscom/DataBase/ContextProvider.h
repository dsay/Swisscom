#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol ContextProviderProtocol <NSObject>

@property (readonly) NSString               * username;
@property (readonly) NSURL                  * databaseDirectory;
@property (readonly) NSManagedObjectContext * mainContext;

@property (readonly) NSPersistentStoreCoordinator * coordinator;

- (NSManagedObjectContext *) createTemporaryContext;
- (NSManagedObjectContext *) createChildContext;

- (void)setupUnAutorizationStore;

- (void)setupForUsername:(NSString*)username;
- (void)cleanDBForCurrentUser;

@end

@interface ContextProvider : NSObject
<
ContextProviderProtocol
>

@end

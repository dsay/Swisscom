#import "ContextProvider.h"

@interface ContextProvider ()

@property (assign) BOOL isSetUp;
@property (nonatomic, strong) NSManagedObjectContext* mainContext;
@property (nonatomic, strong) NSManagedObjectContext* backgroundContext;

@property (strong) NSURL* databaseDirectory;

@end

@implementation ContextProvider

@synthesize username = _username;
@synthesize mainContext = _mainContext;
@synthesize backgroundContext = _backgroundContext;
@synthesize coordinator = _coordinator;

- (NSPersistentStoreCoordinator *)coordinator
{
    return _coordinator;
}

- (void)setupUnAutorizationStore
{
    if (_coordinator) return;
    
    NSURL* directory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                               inDomains:NSUserDomainMask] lastObject];
    NSError* error = nil;
    directory = [directory URLByAppendingPathComponent:@"BD" isDirectory:NO];
    
    id objectModel = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:objectModel];
    
    [self.coordinator addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:@"UnAutorizationUser"
                                         URL:directory
                                     options:nil
                                       error:&error];
    if (error)
    {
        NSError* deleteError = nil;
        [[NSFileManager defaultManager] removeItemAtURL:directory error:&deleteError];
        NSAssert(deleteError == nil, @"Cannot add store at %@ to PSC", directory);
        [self.coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                   configuration:@"UnAutorizationUser"
                                             URL:directory
                                         options:nil
                                           error:&error];
        
        
    }
}

- (void)setupForUsername:(NSString *)username
{
    NSAssert(_isSetUp == NO, @"Setup for username must be called");
    NSAssert(_coordinator != nil, @"UnAutorizationUser coordinator should created first");
    
    if (_coordinator == nil) return;
    if (_isSetUp == YES) return;
    
    NSURL* directory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                               inDomains:NSUserDomainMask] lastObject];
    
    self.databaseDirectory = ({
        
        directory = [directory URLByAppendingPathComponent:username isDirectory:YES];
        if (![[NSFileManager defaultManager] fileExistsAtPath:directory.absoluteString]){
            NSError* error = nil;
            BOOL directoryCreated;
            directoryCreated = [[NSFileManager defaultManager] createDirectoryAtURL:directory
                                                            withIntermediateDirectories:YES
                                                                             attributes:nil
                                                                                  error:&error];
            NSAssert(directoryCreated, @"Unable to create user directory: user %@", username);
        }
        
        directory;
    });
    
    NSString* databaseName = [NSString stringWithFormat:@"database-%@", username];
    NSURL* databaseURL = [self.databaseDirectory URLByAppendingPathComponent:databaseName];
    
    {/// Adding store to PSC
        NSError* error = nil;
        [self.coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                  configuration:@"AutorizationUser"
                                            URL:databaseURL
                                        options:nil
                                          error:&error];
        if (error)
        {
            NSError* deleteError = nil;
            [[NSFileManager defaultManager] removeItemAtURL:databaseURL error:&deleteError];
            NSAssert(deleteError == nil, @"Cannot add store at %@ to PSC", databaseURL);
            [self.coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                       configuration:@"AutorizationUser"
                                                 URL:databaseURL
                                             options:nil
                                               error:&error];
        }
    }

    self.isSetUp = YES;
    _username = username;
}

- (void)cleanDBForCurrentUser
{
    NSAssert(self.isSetUp == YES, @"Setup for username must be called");
    NSAssert(self.mainContext != nil, @"Context shouldn't be empty.");
    
    self.isSetUp = NO;
    
    NSArray *array = self.coordinator.persistentStores;
    for (NSPersistentStore *store in array)
    {
        NSString* databaseName = [NSString stringWithFormat:@"database-%@", _username];
        NSURL* databaseURL = [self.databaseDirectory URLByAppendingPathComponent:databaseName];
        
        if ([store.URL.absoluteString isEqualToString:databaseURL.absoluteString])
        {
            [self.coordinator removePersistentStore:store error:nil];
        }
    }
    _username = nil;
    _databaseDirectory = nil;
}

- (NSManagedObjectContext *)createTemporaryContext
{
    NSAssert(_coordinator != nil, @"Setup  must be called before access to temporaryContext");
    if (!self.coordinator) return nil;
    
    NSManagedObjectContext* fetchContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleDidSaveNotification:)
                                                name:NSManagedObjectContextDidSaveNotification
                                              object:fetchContext];
    
    fetchContext.persistentStoreCoordinator = self.coordinator;
    fetchContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    [fetchContext setRetainsRegisteredObjects:YES];
    return fetchContext;
}

- (NSManagedObjectContext *)createChildContext
{
    NSAssert(_coordinator != nil, @"Setup  must be called before access to fetchContext");
    if (!self.mainContext) return nil;
    
    NSManagedObjectContext* fetchContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    fetchContext.parentContext = self.mainContext;
    fetchContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    [fetchContext setRetainsRegisteredObjects:YES];
    return fetchContext;
}

- (void)setMainContext:(NSManagedObjectContext *)context
{
    _mainContext = context;
}

- (NSManagedObjectContext*)mainContext
{
    NSAssert(_coordinator != nil, @"Setup  must be called before access to mainContext");
    if (!self.coordinator) return nil;
    
    if (!_mainContext)
    {
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setPersistentStoreCoordinator:self.coordinator];
        _mainContext.mergePolicy = NSRollbackMergePolicy;
    }
    return _mainContext;
}

- (void)handleDidSaveNotification:(NSNotification *)notification
{
    NSManagedObjectContext *contex = self.mainContext;
    if (notification.object != contex)
    {
        [contex performBlock:^{
            [contex mergeChangesFromContextDidSaveNotification:notification];
            NSError *error = nil;
            
            BOOL success = [contex save:&error];
            if (!success) {
            }
            
            NSAssert(error == nil, @"Save main Context : %@", error);
        }];
    }
}

@end

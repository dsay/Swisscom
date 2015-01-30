#import "DataStorage.h"
#import "Singleton.h"
#import "DataStorageRequestBuilder.h"

@implementation DataStorage

SYNTHESIZE_SINGLETON_FOR_CLASS(DataStorage)

static DataStorage *_sharedInstance = nil;

- (BOOL)saveMainContext
{
    NSError *errorSaving = nil;
    BOOL saved = [self.contextProvider.mainContext save:&errorSaving];
    
    return saved;
}

- (id)init
{
    if (self = [super init])
    {
        self.requestBuilder = [DataStorageRequestBuilder new];
    }
    return self;
}

- (NSString *)username
{
    return self.contextProvider.username;
}

- (NSURL *)databaseDirectory
{
    return self.contextProvider.databaseDirectory;
}

- (NSArray *)performFetchRequest:(NSFetchRequest *)fetchRequest
{
    NSError* error = nil;
    NSArray* results = [self.contextProvider.mainContext executeFetchRequest:fetchRequest error:&error];
    NSAssert(error == nil, @"FRC fetch failed : %@", error);
    return results;
}

- (void)performFetchRequest:(NSFetchRequest *)request completeBlock:(void(^)(NSArray* results))block
{
    NSManagedObjectContext* fetchContext = [self.contextProvider createTemporaryContext];
    [fetchContext performBlock:^{
        NSFetchRequest *requestCopy = [request copy];
        [requestCopy setResultType:NSManagedObjectIDResultType];
        [requestCopy setSortDescriptors:nil];
        
        NSError *error = nil;
        NSArray *ids = [fetchContext executeFetchRequest:requestCopy error:&error];
    
        [self.contextProvider.mainContext performBlock:^{
            NSFetchRequest *modifiedRequest = [request copy];
            
            if (ids.count > 0)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self IN %@", ids];
                [modifiedRequest setPredicate:predicate];
                [modifiedRequest setFetchBatchSize:request.fetchBatchSize];
                
                NSError* error = nil;
                NSArray* results = [self.contextProvider.mainContext executeFetchRequest:modifiedRequest error:&error];
                
                NSAssert(error == nil, @"Main context : %@", error);
                block(results);
            }
            else
            {
                block(nil);
            }
        }];
    }];
}

- (void)importRequestWithBlock:(NSDictionary* (^)(NSManagedObjectContext* context))block
                 completeBlock:(void(^)(NSDictionary* dictionary))complete
{
    NSManagedObjectContext *nestedContex = [self.contextProvider createTemporaryContext];
    NSManagedObjectContext *mainContex = self.contextProvider.mainContext;
    
    [nestedContex performBlock:^{
        NSDictionary *objects = block(nestedContex);
        NSError *error = nil;
         
        NSMutableDictionary *objectIDs = [NSMutableDictionary new];
        for (NSString *key in objects.allKeys)
        {
            if ([objects[key] isKindOfClass:[NSManagedObject class]])
            {
                NSManagedObject *object = [objects objectForKey:key];
                if ([object.objectID isTemporaryID])
                    [nestedContex obtainPermanentIDsForObjects:@[object] error:&error];
                
                [objectIDs setObject:object.objectID forKey:key];
            }
        }
        
        BOOL success = [nestedContex save:&error];
        if (!success) {
        }
        
        NSAssert(error == nil, @"Save nested Context : %@", error);
        
        [mainContex performBlock:^{
            
            NSMutableDictionary *permanentObjects = [NSMutableDictionary new];
            for (NSString *key in objectIDs.allKeys) {
                NSManagedObjectID *objectID = [objectIDs objectForKey:key];
                NSManagedObject *object = [mainContex objectWithID:objectID];
                
                [permanentObjects setObject:object forKey:key];
            }
                    
            [mainContex obtainPermanentIDsForObjects:permanentObjects.allValues
                                               error:nil];
            
            if (complete)
                complete(permanentObjects);
        }];
    }];
}

@end

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^DataStorageResultsBlock)(NSArray*);
typedef void(^DataStorageImportResultsBlock)(NSDictionary*);
typedef NSDictionary* (^DataStorageImportBlock)(NSManagedObjectContext* context);

@protocol RequestBuilderProtocol <NSObject>

- (NSFetchRequest *)allMessages;

@end

@protocol DataStorageProtocol <NSObject>

@property (readonly) id<RequestBuilderProtocol>   requestBuilder;
@property (readonly) NSString                     * username;
@property (readonly) NSURL                        * databaseDirectory;

- (NSArray *)performFetchRequest:(NSFetchRequest *)fetchRequest;

- (void)performFetchRequest:(NSFetchRequest *)fetchRequest
              completeBlock:(DataStorageResultsBlock)block;

- (void)importRequestWithBlock:(DataStorageImportBlock)block
                 completeBlock:(DataStorageImportResultsBlock)complete;

@end

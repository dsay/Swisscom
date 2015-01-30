#import <Foundation/Foundation.h>
#import "DataStorageProtocol.h"
#import "ContextProvider.h"

@interface DataStorage : NSObject
<
DataStorageProtocol
>

@property (strong) id<RequestBuilderProtocol>    requestBuilder;
@property (strong) id<ContextProviderProtocol>   contextProvider;

+ (DataStorage *)shared;

- (BOOL)saveMainContext;

@end

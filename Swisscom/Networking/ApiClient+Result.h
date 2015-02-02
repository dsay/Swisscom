#import "ApiClient.h"

@interface ApiClient (Result)

- (AFHTTPRequestOperation *)uploadResults:(NSArray *)results completion:(completionBlock)completion;

@end

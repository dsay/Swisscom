#import "ApiClient.h"

@interface ApiClient (Question)

- (AFHTTPRequestOperation *)questionsCompletion:(completionBlock)completion;

@end

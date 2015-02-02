#import "ApiClient+Result.h"
#import "SWResult.h"

@implementation ApiClient (Result)

- (AFHTTPRequestOperation *)uploadResults:(NSArray *)results completion:(completionBlock)completion
{
    AFHTTPRequestOperation *operation =
    [self.manager POST:@"results"
            parameters:@{}
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   [self handleResponse:responseObject complete:completion];
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   [self handleError:error complete:completion];
               }];
    return operation;
}

@end

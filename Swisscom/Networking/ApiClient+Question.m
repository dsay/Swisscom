#import "ApiClient+Question.h"

@implementation ApiClient (Question)

- (AFHTTPRequestOperation *)questionsCompletion:(completionBlock)completion
{
    AFHTTPRequestOperation *operation =
    [self.manager GET:@"questions"
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [self handleResponse:responseObject complete:completion];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self handleError:error complete:completion];
              }];
    return operation;
}

@end

#import "ApiClient.h"
#import "Singleton.h"

@implementation ApiClient

SYNTHESIZE_SINGLETON_FOR_CLASS(ApiClient)

- (instancetype)init
{
    if (self = [super initWithBaseURL:[NSURL URLWithString:@""]]) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return self;
}

- (void)cancelOperation:(AFHTTPRequestOperation *)operation
{
    NSAssert(operation != nil, @"Not setup for HTTP Request Operation");
    if (!operation)
        return;

    if (operation.isCancelled) return;
    
    [operation cancel];
}

#pragma mark - Base requests

+ (void)handleResponse:(id)responseObject complete:(completionBlock)block
{
    if (responseObject == nil) block(@"Error - no response", nil, 500);
    block(@"", responseObject, 200);
}

+ (AFHTTPRequestOperation *)POST:(NSString *)postPath parameters:(NSDictionary *)params complete:(completionBlock)block
{
    ApiClient *client = [ApiClient shared];
    return [client POST:postPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self handleResponse:responseObject complete:block];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleResponse:operation.responseObject complete:block];
    }];
}


+ (AFHTTPRequestOperation *)GET:(NSString *)getPath parameters:(NSDictionary *)params complete:(completionBlock)block
{
    ApiClient *client = [ApiClient shared];
   return [client GET:getPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleResponse:responseObject complete:block];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleResponse:operation.responseObject complete:block];
    }];
}

@end

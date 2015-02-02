#import "ApiClient.h"
#import "DPDataMapper.h"

static NSString * const kBaseURL = @"http://www.swisscom.com";
static NSString * const kStatus = @"status";
static NSString * const kData = @"data";

@implementation ApiClient

- (instancetype)init
{
    if (self = [super init])
    {
        NSURL *baseURL = [NSURL URLWithString:kBaseURL];
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    }
    return self;
}

- (void)handleResponse:(id)responseObject complete:(completionBlock)completion
{
    DPDataMapper *mapper = [DPDataMapper new];
    [mapper setResponse:responseObject];
    
    if ([[mapper stringFromKey:kStatus] isEqualToString:@"OK"])
    {
        if ([mapper dictionaryForKey:kData])
        {
            completion([mapper dictionaryForKey:kData], nil);
        }
        else
        {
            completion(nil, @"Error not valid data !");
        }
    }
    else
    {
        completion(nil, @"Error not valid data !");
    }
#if DEBUG
    NSLog(@"Server response:%@", responseObject);
#endif
}

- (void)handleError:(NSError *)error complete:(completionBlock)completion
{
    completion(nil, error.localizedDescription);
    
#if DEBUG
    NSLog(@"Server error:%@", error);
#endif
}

@end
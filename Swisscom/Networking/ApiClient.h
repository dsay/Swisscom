#import <AFNetworking/AFNetworking.h>

#define kMaxConcurrentOperationCount 5

typedef  void (^completionBlock)(NSDictionary *dict, NSString *error);

@interface ApiClient : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

- (void)handleResponse:(id)responseObject complete:(completionBlock)completion;
- (void)handleError:(NSError *)error complete:(completionBlock)completion;

@end

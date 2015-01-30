#import <AFNetworking/AFHTTPRequestOperationManager.h>

#define kMaxConcurrentOperationCount 5

typedef  void (^completionBlock)(NSString *error, NSDictionary  *dict, NSInteger statusCode) ;
typedef  void (^completionFileBlock)(NSString *error, NSData * data) ;

@interface ApiClient : AFHTTPRequestOperationManager

+ (ApiClient *)shared;

- (void)cancelOperation:(AFHTTPRequestOperation *)operation;

+ (AFHTTPRequestOperation *)GET:(NSString *)getPath
                      parameters:(NSDictionary *)params
                        complete:(completionBlock)block;

+ (AFHTTPRequestOperation *)POST:(NSString *)postPath
                      parameters:(NSDictionary *)params
                        complete:(completionBlock)block;

+ (void)handleResponse:(id)responseObject complete:(completionBlock)block;

@end

#import "AppDelegate.h"

#import "EventSynchronizationService.h"
#import "DataStorage.h"
#import "DataStorageRequestBuilder.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DataStorage *dataStorage = [DataStorage shared];
    ContextProvider *provider = [ContextProvider new];
    DataStorageRequestBuilder *builder = [DataStorageRequestBuilder new];
    
    [provider setupUnAutorizationStore];
    
    dataStorage.contextProvider = provider;
    dataStorage.requestBuilder = builder;
    
    [[EventSynchronizationService shared] beginSyncing];
    
    return YES;
}

- (void)loginStub
{
    id<OHHTTPStubsDescriptor> loginStub = nil;
    loginStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://www.mvc.com/demos/login?email=www%40www.www&password=wwwwww"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"login.txt",nil)
                                                 statusCode:200
                                                    headers:@{@"Content-Type":@"text/plain"}]
                
                
                requestTime:1.f
                responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
    loginStub.name = @"Login stub";
}

@end

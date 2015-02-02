#import "AppDelegate.h"

#import "EventSynchronizationService.h"
#import "DataStorage.h"
#import "DataStorageRequestBuilder.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "SynchronizationService.h"
#import "ApiClient.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DataStorage *dataStorage = [DataStorage shared];
    ContextProvider *provider = [ContextProvider new];
    DataStorageRequestBuilder *builder = [DataStorageRequestBuilder new];
    
    dataStorage.contextProvider = provider;
    dataStorage.requestBuilder = builder;
    
    [provider setupUnAutorizationStore];

    ApiClient *apiclient = [ApiClient new];
    [EventSynchronizationService shared].apiClient = apiclient;
    [SynchronizationService shared].apiClient = apiclient;
    
    [[EventSynchronizationService shared] beginSyncing];

    [self questionsStub];
    [self resultsStub];

    return YES;
}

- (void)questionsStub
{
    id<OHHTTPStubsDescriptor> questionsStub = nil;
    questionsStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://www.swisscom.com/questions"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"Questions.json",nil)
                                                 statusCode:200
                                                    headers:@{@"Content-Type":@"application/json"}]
                
                
                requestTime:1.f
                responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
    questionsStub.name = @"Questions stub";
}

- (void)resultsStub
{
    id<OHHTTPStubsDescriptor> resultsStub = nil;
    resultsStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://www.swisscom.com/results"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"Results.json",nil)
                                                 statusCode:200
                                                    headers:@{@"Content-Type":@"application/json"}]
                
                
                requestTime:1.f
                responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
    resultsStub.name = @"Results stub";
}

@end

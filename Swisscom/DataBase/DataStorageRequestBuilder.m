#import "DataStorageRequestBuilder.h"

@implementation DataStorageRequestBuilder

- (NSFetchRequest *)questions
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"SWQuestion"];    
    return request;
}

@end

#import "DataStorageRequestBuilder.h"

@implementation DataStorageRequestBuilder

- (NSFetchRequest *)questions
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"SWQuestion"];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"qustionId" ascending:YES]]];
    return request;
}

@end

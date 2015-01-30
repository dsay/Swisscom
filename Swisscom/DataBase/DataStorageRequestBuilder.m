#import "DataStorageRequestBuilder.h"

@implementation DataStorageRequestBuilder

- (NSFetchRequest *)allMessages
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Message"];
 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    
    return request;
}

@end

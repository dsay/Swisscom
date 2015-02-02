#import "UserResult.h"
#import "DataStorage.h"

#import "SWResult.h"
#import "SWResponse.h"

@interface UserResult ()

@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation UserResult

- (instancetype)init
{
    if (self = [super init])
    {
        _dict = [NSMutableDictionary new];
    }
    return self;
}

- (void)setAnswer:(NSNumber *)aswerId forQuestion:(NSNumber *)questionId
{
    [self.dict setValue:aswerId forKey:questionId.stringValue];
}

- (NSNumber *)answerForQuestion:(NSNumber *)questionId
{
    return [self.dict valueForKey:questionId.stringValue];
}

- (void)save
{
    DataStorage *dataStorage = [DataStorage shared];
    [dataStorage importRequestWithBlock:^NSDictionary *(NSManagedObjectContext *context) {
        
        SWResult *result = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(SWResult.class)
                                                         inManagedObjectContext:context];

        for (NSString *key in self.dict.allKeys)
        {
            NSNumber *questionId = @(key.integerValue);
            NSNumber *answerId = [self answerForQuestion:questionId];
            
            SWResponse *respounse = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(SWResponse.class)
                                                                  inManagedObjectContext:context];
            respounse.answerId = answerId;
            respounse.qustionId = questionId;
            
            [result addResponsesObject:respounse];
        }

        return @{@"result" : result};
    } completeBlock:^(NSDictionary *dict) {
        
    }];
}

@end

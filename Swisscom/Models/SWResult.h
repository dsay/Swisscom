#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWResponse, SWResultTimingEvent;

@interface SWResult : NSManagedObject

@property (nonatomic, retain) NSSet *responses;
@property (nonatomic, retain) SWResultTimingEvent *timingEvent;
@end

@interface SWResult (CoreDataGeneratedAccessors)

- (void)addResponsesObject:(SWResponse *)value;
- (void)removeResponsesObject:(SWResponse *)value;
- (void)addResponses:(NSSet *)values;
- (void)removeResponses:(NSSet *)values;

@end

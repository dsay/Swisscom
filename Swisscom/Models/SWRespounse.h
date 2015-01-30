#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWAnswer, SWRespounseTimingEvent;

@interface SWRespounse : NSManagedObject

@property (nonatomic, retain) NSSet *answers;
@property (nonatomic, retain) SWRespounseTimingEvent *timingEvent;
@end

@interface SWRespounse (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(SWAnswer *)value;
- (void)removeAnswersObject:(SWAnswer *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

@end

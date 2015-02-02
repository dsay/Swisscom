#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWAnswer, SWScore;

@interface SWQuestion : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * qustionId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSSet *answers;
@property (nonatomic, retain) SWScore *score;
@end

@interface SWQuestion (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(SWAnswer *)value;
- (void)removeAnswersObject:(SWAnswer *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

@end

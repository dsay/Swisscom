#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWAnswer;

@interface SWQuestion : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * qustionId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *answers;
@property (nonatomic, retain) NSData *imageData;

@end

@interface SWQuestion (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(SWAnswer *)value;
- (void)removeAnswersObject:(SWAnswer *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

@end

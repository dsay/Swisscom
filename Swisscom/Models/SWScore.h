#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWQuestion;

@interface SWScore : NSManagedObject

@property (nonatomic, retain) NSNumber * min;
@property (nonatomic, retain) NSNumber * max;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) SWQuestion *question;

@end

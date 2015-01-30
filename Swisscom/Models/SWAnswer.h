#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWQuestion;

@interface SWAnswer : NSManagedObject

@property (nonatomic, retain) NSNumber * answerId;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) SWQuestion *qustion;

@end

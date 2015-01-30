#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SWAnswer : NSManagedObject

@property (nonatomic, retain) NSNumber * qustionId;
@property (nonatomic, retain) NSNumber * variantId;
@property (nonatomic, retain) NSManagedObject *respounse;

@end

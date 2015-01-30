#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SWVariant : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * variantId;
@property (nonatomic, retain) NSManagedObject *qustion;

@end

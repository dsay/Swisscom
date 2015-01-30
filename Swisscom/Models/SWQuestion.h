#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWVariant;

@interface SWQuestion : NSManagedObject

@property (nonatomic, retain) NSNumber * qustionId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSSet *variats;
@end

@interface SWQuestion (CoreDataGeneratedAccessors)

- (void)addVariatsObject:(SWVariant *)value;
- (void)removeVariatsObject:(SWVariant *)value;
- (void)addVariats:(NSSet *)values;
- (void)removeVariats:(NSSet *)values;

@end

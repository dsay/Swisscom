#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWResult;

@interface SWResultTimingEvent : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) SWResult *result;

@end

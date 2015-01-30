#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWRespounse;

@interface SWRespounseTimingEvent : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) SWRespounse *respounse;

@end

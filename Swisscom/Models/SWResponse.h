#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWResult;

@interface SWResponse : NSManagedObject

@property (nonatomic, retain) NSNumber * answerId;
@property (nonatomic, retain) NSNumber * qustionId;
@property (nonatomic, retain) SWResult *result;

@end

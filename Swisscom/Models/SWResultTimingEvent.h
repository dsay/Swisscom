//
//  SWResultTimingEvent.h
//  Swisscom
//
//  Created by Dima on 1/30/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWResult;

@interface SWResultTimingEvent : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) SWResult *result;

@end

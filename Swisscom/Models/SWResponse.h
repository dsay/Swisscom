//
//  SWResponse.h
//  Swisscom
//
//  Created by Dima on 1/30/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWResult;

@interface SWResponse : NSManagedObject

@property (nonatomic, retain) NSNumber * answerId;
@property (nonatomic, retain) NSNumber * qustionId;
@property (nonatomic, retain) SWResult *result;

@end

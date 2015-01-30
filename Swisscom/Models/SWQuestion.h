//
//  SWQuestion.h
//  Swisscom
//
//  Created by Dima on 1/30/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SWAnswer;

@interface SWQuestion : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * qustionId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *answers;
@end

@interface SWQuestion (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(SWAnswer *)value;
- (void)removeAnswersObject:(SWAnswer *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

@end

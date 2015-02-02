//
//  QuestionHeaderView.h
//  Swisscom
//
//  Created by Anatoly Tukhtarov on 1/31/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

@import UIKit;

@class SWQuestion;

@interface QuestionHeaderView : UICollectionReusableView
@property (nonatomic, readonly) SWQuestion *question;
- (void)configureWithQuestion:(SWQuestion *)question;
@end

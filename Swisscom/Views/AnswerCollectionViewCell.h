//
//  AnswerCollectionViewCell.h
//  Swisscom
//
//  Created by Anatoly Tukhtarov on 1/31/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

@import UIKit;

@class SWAnswer;

@interface AnswerCollectionViewCell : UICollectionViewCell
@property (nonatomic, readonly) SWAnswer *answer;

- (void)configureWithAnswer:(SWAnswer *)answer;
@end

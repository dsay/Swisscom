//
//  QuestionDataSource.h
//  Swisscom
//
//  Created by Anatoly Tukhtarov on 1/31/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

#import "UserResult.h"
@import UIKit;

@class SWQuestion;

@interface QuestionDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) SWQuestion *question;
@property (nonatomic, assign) NSInteger selectedQuestionIndex;
@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, readonly) UserResult *result;
@property (nonatomic, copy) void (^completionHandler)(UserResult *result);

- (instancetype)initWithQuestions:(NSArray *)questions;
- (void)nextQuestion;
- (void)previousQuestion;

- (void)registerReusableViewsInCollectionView:(UICollectionView *)collectionView;
- (CGSize)collectionView:(UICollectionView *)collectionView sizeFittingSize:(CGSize)fittingSize forItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)collectionView:(UICollectionView *)collectionView sizeFittingSize:(CGSize)fittingSize forSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
@end

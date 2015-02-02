//
//  QuestionDataSource.m
//  Swisscom
//
//  Created by Anatoly Tukhtarov on 1/31/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

#import "QuestionDataSource.h"
#import "AnswerCollectionViewCell.h"
#import "QuestionHeaderView.h"
#import "SWQuestion.h"
#import "SWAnswer.h"

@interface QuestionDataSource ()
@property (nonatomic, copy) NSArray *answers;
@end

@implementation QuestionDataSource
- (instancetype)initWithQuestions:(NSArray *)questions {
    if (self = [super init]) {
        _questions = [questions copy];
        _result = [UserResult new];
        _selectedQuestionIndex = 0;
        self.question = _questions[_selectedQuestionIndex];
        
    }
    
    return self;
}

#pragma mark - QuestionDataSource
- (void)nextQuestion {
    if (_selectedQuestionIndex < (_questions.count - 1)) {
        ++_selectedQuestionIndex;
    } else {
        if (self.completionHandler) {
            self.completionHandler(self.result);
        }
    }
    self.question = self.questions[self.selectedQuestionIndex];
}

- (void)previousQuestion {
    if (_selectedQuestionIndex > 0) {
        --_selectedQuestionIndex;
    }
    self.question = self.questions[self.selectedQuestionIndex];
}

- (void)setQuestion:(SWQuestion *)question {
    if ([question isEqual:_question]) {
        return;
    }
    
    _question = question;
    NSArray *answers = [question.answers allObjects];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"answerId" ascending:YES];
    self.answers = [answers sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (void)registerReusableViewsInCollectionView:(UICollectionView *)collectionView {
    NSString *identifier = NSStringFromClass([QuestionHeaderView class]);
    [collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.answers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AnswerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AnswerCollectionViewCell class]) forIndexPath:indexPath];
    SWAnswer *answer = self.answers[indexPath.item];
    [cell configureWithAnswer:answer];
    if ([[self.result answerForQuestion:self.question.qustionId] isEqualToNumber:answer.answerId]) {
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        QuestionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([QuestionHeaderView class]) forIndexPath:indexPath];
        [view configureWithQuestion:self.question];
        return view;
    }
    
    return nil;
}

#pragma mark - Sizes
- (CGSize)collectionView:(UICollectionView *)collectionView sizeFittingSize:(CGSize)fittingSize forItemAtIndexPath:(NSIndexPath *)indexPath {
    AnswerCollectionViewCell *cell = (AnswerCollectionViewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    CGRect frame = cell.frame;
    frame.size = fittingSize;
    cell.frame = frame;
    
    [cell layoutIfNeeded];
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeFittingSize:(CGSize)fittingSize forSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        QuestionHeaderView *view = (QuestionHeaderView *)[self collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
        
        CGRect frame = view.frame;
        frame.size = fittingSize;
        view.frame = frame;
        
        [view layoutIfNeeded];
        CGSize size = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        size.width = CGRectGetWidth(collectionView.bounds);
        return size;
    }
    
    return fittingSize;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SWAnswer *answer = self.answers[indexPath.item];
    [self.result setAnswer:answer.answerId forQuestion:self.question.qustionId];
}
@end

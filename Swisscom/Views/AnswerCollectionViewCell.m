//
//  AnswerCollectionViewCell.m
//  Swisscom
//
//  Created by Anatoly Tukhtarov on 1/31/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

#import "AnswerCollectionViewCell.h"
#import "SWAnswer.h"
#import "UIImageView+AFNetworking.h"

@interface AnswerCollectionViewCell ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@end

@implementation AnswerCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    self.selectedBackgroundView = view;
}

- (void)configureWithAnswer:(SWAnswer *)answer {
    _answer = answer;
    if (self.answer.imageData) {
        self.imageView.image = [UIImage imageWithData:self.answer.imageData];
    }
    self.textLabel.text = self.answer.title;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}
@end

//
//  QuestionHeaderView.m
//  Swisscom
//
//  Created by Anatoly Tukhtarov on 1/31/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

#import "QuestionHeaderView.h"
#import "SWQuestion.h"
#import "UIImageView+AFNetworking.h"

@interface QuestionHeaderView ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@end

@implementation QuestionHeaderView
- (void)configureWithQuestion:(SWQuestion *)question {
    _question = question;
    if (self.question.imageData) {
        self.imageView.image = [UIImage imageWithData:self.question.imageData];
    }
    
    self.textLabel.text = self.question.title;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}
@end

//
//  PlaceholderView.m
//  Swisscom
//
//  Created by Anatoly Tukhtarov on 2/2/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

#import "PlaceholderView.h"

@interface PlaceholderView ()
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailsTextLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation PlaceholderView
- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    
    return self;
}

- (void)showActivityIndicator {
    [self.activityIndicator startAnimating];
    self.textLabel.hidden = YES;
    self.detailsTextLabel.hidden = YES;
}

- (void)hideActivityIndicator {
    [self.activityIndicator stopAnimating];
}

- (void)showMessageWithTitle:(NSString *)title message:(NSString *)message {
    self.textLabel.hidden = NO;
    self.textLabel.text = title;
    
    self.detailsTextLabel.hidden = NO;
    self.detailsTextLabel.text = message;
}
@end

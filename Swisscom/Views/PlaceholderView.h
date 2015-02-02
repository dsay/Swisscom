//
//  PlaceholderView.h
//  Swisscom
//
//  Created by Anatoly Tukhtarov on 2/2/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

@import UIKit;

@interface PlaceholderView : UIView
@property (nonatomic, readonly, weak) UILabel *textLabel;
@property (nonatomic, readonly, weak) UILabel *detailsTextLabel;
@property (nonatomic, readonly, weak) UIActivityIndicatorView *activityIndicator;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (void)showMessageWithTitle:(NSString *)title message:(NSString *)message;
@end

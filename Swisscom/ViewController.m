//
//  ViewController.m
//  Swisscom
//
//  Created by Dima on 1/30/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

#import "ViewController.h"
#import "ApiClient+Question.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[ApiClient shared] questionsCompletion:^(NSDictionary *dict, NSString *error) {
        
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  Swisscom
//
//  Created by Dima on 1/30/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

#import "ViewController.h"
#import "SynchronizationService.h"
#import "DataStorage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SynchronizationService shared] startSynchronizationSuccess:^(BOOL success) {
        [self fetchData];
    }];
    [self fetchData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)fetchData
{
    DataStorage *dataStorage = [DataStorage shared];
    NSFetchRequest *request = [dataStorage.requestBuilder questions];
    NSArray *questions = [dataStorage performFetchRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

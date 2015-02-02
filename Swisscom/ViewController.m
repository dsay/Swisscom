#import "ViewController.h"
#import "SynchronizationService.h"
#import "DataStorage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[SynchronizationService shared] startSynchronizationSuccess:^(BOOL success) {
        [self fetchData];
    }];
    
    [self fetchData];
}

- (void)fetchData
{
    DataStorage *dataStorage = [DataStorage shared];
    NSFetchRequest *request = [dataStorage.requestBuilder questions];
    NSArray *question = [dataStorage performFetchRequest:request];
}

@end

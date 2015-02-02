#import "ViewController.h"
#import "SynchronizationService.h"
#import "DataStorage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *question = [self fetchData];
    if (question.count)
    {
//        Update UI
    }
    else
    {
//     Start Spiner
        [[SynchronizationService shared] startSynchronizationSuccess:^(BOOL success) {
           NSArray *question = [self fetchData];
            if (success && question.count)
            {
//                  Update UI
            }
            else
            {
//                  ERROR
            }
//          Stop Spiner
        }];
    }
}

- (NSArray *)fetchData
{
    DataStorage *dataStorage = [DataStorage shared];
    NSFetchRequest *request = [dataStorage.requestBuilder questions];
    return [dataStorage performFetchRequest:request];
}

@end

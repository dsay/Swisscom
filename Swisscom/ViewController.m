#import "ViewController.h"
#import "SynchronizationService.h"
#import "DataStorage.h"
#import "PlaceholderView.h"
#import "QuestionDataSource.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) PlaceholderView *placeholdeView;
@property (nonatomic, strong) QuestionDataSource *dataSource;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButtonItem;

- (IBAction)backButtonTapHandler:(UIBarButtonItem *)sender;
- (IBAction)nextButtonTapHanlder:(UIBarButtonItem *)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backButtonItem.enabled = NO;
    self.nextButtonItem.enabled = NO;
    [self.placeholdeView showActivityIndicator];
    
    NSArray *question = [self fetchData];
    if (question.count)
    {
        [self configureDataSourceWithQuestions:question];
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [[SynchronizationService shared] startSynchronizationSuccess:^(BOOL success) {
           NSArray *question = [weakSelf fetchData];
            if (success && question.count)
            {
                [weakSelf configureDataSourceWithQuestions:question];
            }
            else
            {
                [weakSelf.placeholdeView hideActivityIndicator];
                [weakSelf.placeholdeView showMessageWithTitle:@"Unable to load questionnaire" message:@"Please, check your internet connection"];
            }
        }];
    }
}

- (NSArray *)fetchData
{
    DataStorage *dataStorage = [DataStorage shared];
    NSFetchRequest *request = [dataStorage.requestBuilder questions];
    return [dataStorage performFetchRequest:request];
}


- (PlaceholderView *)placeholdeView
{
    if (_placeholdeView == nil) {
        _placeholdeView = [PlaceholderView new];
        _placeholdeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_placeholdeView];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_placeholdeView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_placeholdeView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_placeholdeView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_placeholdeView)]];
    }
    
    return _placeholdeView;
}

- (void)removePlaceholderView
{
    [self.placeholdeView hideActivityIndicator];
    [self.placeholdeView removeFromSuperview];
    self.placeholdeView = nil;
}

- (void)configureDataSourceWithQuestions:(NSArray *)questions
{
    self.nextButtonItem.enabled = YES;
    [self removePlaceholderView];
    self.dataSource = [[QuestionDataSource alloc] initWithQuestions:questions];
    [self.dataSource registerReusableViewsInCollectionView:self.collectionView];
    __weak typeof(self) weakSelf = self;
    self.dataSource.completionHandler = ^(UserResult *result) {
        [result save];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Questionnaire rusults are saved!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    };
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self.dataSource;
    [self.collectionView reloadData];
}

- (IBAction)backButtonTapHandler:(UIBarButtonItem *)sender
{
    if (self.dataSource.selectedQuestionIndex == 0) {
        self.backButtonItem.enabled = NO;
    }
    
    [self.dataSource previousQuestion];
    [self.collectionView reloadData];
}

- (IBAction)nextButtonTapHanlder:(UIBarButtonItem *)sender
{
    self.backButtonItem.enabled = YES;
    [self.dataSource nextQuestion];
    [self.collectionView reloadData];
}
@end

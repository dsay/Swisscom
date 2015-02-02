#import "QuestionsMapper.h"
#import "DPDataMapper.h"
#import "SWQuestion.h"
#import "SWAnswer.h"

static NSString * const kQuestions = @"questions";
static NSString * const kID = @"id";
static NSString * const kTitle = @"title";
static NSString * const kImage = @"image";
static NSString * const kAnswers = @"answers";

@implementation QuestionsMapper

+ (void)importQuestionsData:(NSDictionary *)questions
                  toContext:(NSManagedObjectContext *)context
{
    NSParameterAssert([questions isKindOfClass:[NSDictionary class]]);
    
    DPDataMapper *mapper = [DPDataMapper new];
    mapper.response = questions;
    
    for (NSDictionary *question in [mapper arrayFromKey:kQuestions]) {
        SWQuestion *questionObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(SWQuestion.class)
                                                                   inManagedObjectContext:context];
        DPDataMapper *questionMapper = [DPDataMapper new];
        questionMapper.response = question;
    
        questionObject.qustionId = [questionMapper integerFromKey:kID];
        questionObject.title = [questionMapper stringFromKey:kTitle];
        questionObject.image = [questionMapper stringFromKey:kImage];
        
        if (questionObject.image)
        {
            NSData *imageData = [self loadData:questionObject.image];
            questionObject.imageData = imageData;
        }
        
        NSArray *answers = [questionMapper arrayFromKey:kAnswers];
        for (NSDictionary *answer in answers)
        {
            SWAnswer *answerObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(SWAnswer.class)
                                                                       inManagedObjectContext:context];
            DPDataMapper *answerMapper = [DPDataMapper new];
            answerMapper.response = answer;
            
            answerObject.answerId = [answerMapper integerFromKey:kID];
            answerObject.title = [answerMapper stringFromKey:kTitle];
            answerObject.image = [answerMapper stringFromKey:kImage];
            
            if (answerObject.image)
            {
                NSData *imageData = [self loadData:answerObject.image];
                answerObject.imageData = imageData;
            }
            
            [questionObject addAnswersObject:answerObject];
        }
        
    }
}

+ (NSData *)loadData:(NSString *)url
{
    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    return imageData;
}

@end

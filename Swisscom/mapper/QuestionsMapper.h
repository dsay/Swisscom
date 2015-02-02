#import <Foundation/Foundation.h>
#import "DataStorage.h"

@interface QuestionsMapper : NSObject

+ (void)importQuestionsData:(NSDictionary *)questions
                toContext:(NSManagedObjectContext *)context;

@end

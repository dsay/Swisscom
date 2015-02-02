#import <Foundation/Foundation.h>

@interface UserResult : NSObject

- (void)setAnswer:(NSNumber *)aswerId forQuestion:(NSNumber *)questionId;
- (NSNumber *)answerForQuestion:(NSNumber *)questionId;

- (void)save;

@end

#import <Foundation/Foundation.h>

@interface DPDataMapper : NSObject

@property (nonatomic, strong) NSDictionary *response;

- (id)objectForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (NSArray *)arrayFromKey:(NSString *)key;
- (NSSet *)setFromKey:(NSString *)key;
- (NSNumber *)doubleFromKey:(NSString *)key;
- (NSNumber *)integerFromKey:(NSString *)key;
- (NSNumber *)boolFromKey:(NSString *)key;
- (NSString *)stringFromKey:(NSString *)key;

@end

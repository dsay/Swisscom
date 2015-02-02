#import "DPDataMapper.h"

@implementation DPDataMapper

- (void)setResponse:(NSDictionary *)response
{
    NSParameterAssert([response isKindOfClass:[NSDictionary class]]);
    if ([response isKindOfClass:[NSDictionary class]])
        _response = [response copy];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
    return [self dictionaryFromValue:[self.response objectForKey:key]];
}

- (NSArray *)arrayFromKey:(NSString *)key
{
    return[self arrayFromValue:[self.response objectForKey:key]];
}

- (NSSet *)setFromKey:(NSString *)key
{
   return [self setFromValue:[self.response objectForKey:key]];
}

- (NSNumber *)doubleFromKey:(NSString *)key
{
    return [self doubleFromValue:[self.response objectForKey:key]];
}

- (NSNumber *)integerFromKey:(NSString *)key
{
    return [self integerFromValue:[self.response objectForKey:key]];
}

- (NSNumber *)boolFromKey:(NSString *)key
{
    return [self boolFromValue:[self.response objectForKey:key]];
}

- (NSString *)stringFromKey:(NSString *)key
{
    return [self stringFromValue:[self.response objectForKey:key]];
}

- (id)objectForKey:(NSString *)key
{
    return [self.response objectForKey:key];
}

#pragma mark - Value parsing

- (NSDictionary *)dictionaryFromValue:value
{
    if ([value isKindOfClass:[NSDictionary class]]) return value;
    
    return nil;
}

- (NSArray *)arrayFromValue:(id)value
{
    if ([value isKindOfClass:[NSArray class]]) return value;
    
    return nil;
}

- (NSSet *)setFromValue:(id)value
{
    if ([value isKindOfClass:[NSSet class]]) return value;
    if ([value isKindOfClass:[NSArray class]]) return [NSSet setWithArray:value];
    
    return nil;
}

- (NSNumber *)doubleFromValue:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]])
    {
        return [NSNumber numberWithDouble:[value doubleValue]];
    }
    
    return nil;
}

- (NSNumber *)boolFromValue:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) return value;
    
    return nil;
}

- (NSNumber *)integerFromValue:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) return [self integerFromString:value];
    
    return nil;
}

- (NSNumber *)integerFromString:(NSString *)value;
{
    return [NSNumber numberWithInteger:[value integerValue]];
}

- (NSString *)stringFromValue:(id)value;
{
    
    if ([value isKindOfClass:[NSString class]]) return value;
    if ([value isKindOfClass:[NSNumber class]]) return [self stringFromNumber:value];
    
    return nil;
}

- (NSString *)stringFromNumber:(NSNumber *)number
{
    return [number stringValue];
}

@end

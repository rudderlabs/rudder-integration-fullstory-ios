//
//  RudderFullStoryIntegration.m
//  Pods-Rudder-FullStory
//
//  Created by Abhishek Pandey on 07/07/21.
//

#import "RudderFullStoryIntegration.h"
#import <FullStory/FullStory.h>

@implementation RudderFullStoryIntegration

- (instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(RSClient *)client {
    self = [super init];
    return self;
}

- (void) processRudderEvent: (nonnull RSMessage *) message {
    NSString *type = message.type;
    if ([type isEqualToString:@"identify"])
    {
        NSMutableDictionary<NSString*, NSObject*>* traits = [message.context.traits mutableCopy];
        if (!isEmpty(traits)) {
            [traits removeObjectForKey:@"userId"];
        }
        if (!isEmpty(message.userId)) {
            [FS identify:message.userId userVars:traits];
            return;
        }
        [FS setUserVars:traits];
    }
    else if ([type isEqualToString:@"track"])
    {
        if (!isEmpty(message.event)) {
            [FS event:[self getTrimKey:message.event] properties:[self getSuffixProperty:message.properties]];
            return;
        }
        [RSLogger logDebug:@"Event name is not present in the Track call. Hence, event not sent"];
    }
    else if ([type isEqualToString:@"screen"])
    {
        if (!isEmpty(message.event)) {
            NSMutableDictionary *screenProperties = [self getSuffixProperty:message.properties];
            if (isEmpty(screenProperties)) {
                screenProperties = [[NSMutableDictionary alloc] init];
            }
            [screenProperties setObject:message.event forKey:@"name"];
            [FS event:@"Screen Viewed" properties:screenProperties];
            return;
        }
        [RSLogger logDebug:@"Event name is not present in the Screen call. Hence, event not sent"];
    }
    else
    {
        [RSLogger logDebug:@"FullStory Integration: Message type not supported"];
    }
}

- (void)dump:(nonnull RSMessage *)message {
    @try
    {
        if (message != nil)
        {
            dispatch_async(dispatch_get_main_queue(),^{
                [self processRudderEvent:message];
            });
        }
    }
    @catch (NSException *ex)
    {
        [RSLogger logError:[[NSString alloc] initWithFormat:@"%@", ex]];
    }
}

- (NSMutableDictionary *)getSuffixProperty:(NSDictionary *)properties {
    if (isEmpty(properties)){
        return nil;
    }
    NSMutableDictionary *suffixedProperty = [[NSMutableDictionary alloc] init];
    for (NSString *propertyKey in properties) {
        NSObject *value = properties[propertyKey];
        NSString *key = [[propertyKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        // default to no suffix;
        NSString *suffix = @"";
        if ([value isKindOfClass:[NSNumber class]]) {
            // defaut to int
            suffix = @"_int";
            NSNumber *n = (NSNumber *) value;
            const char *typeCode = n.objCType;
            if (n == (void*)kCFBooleanFalse || n == (void*)kCFBooleanTrue) {
                suffix = @"_bool";
            } else if (!strcmp(typeCode,"f") || !strcmp(typeCode,"d")) {
                suffix = @"_real";
            }
        } else if([value isKindOfClass:[NSString class]]) {
            suffix = @"_str";
        } else if ([value isKindOfClass:[NSDate class]]) {
            suffix = @"_date";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setLocale:enUSPOSIXLocale];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
            [dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
            NSDate *date = (NSDate *)value;
            NSString *iso8601String = [dateFormatter stringFromDate:date];
            [suffixedProperty setObject:iso8601String forKey:[key stringByAppendingString:suffix]];
            continue;
        }
        [suffixedProperty setObject:value forKey:[key stringByAppendingString:suffix]];
    }
    return suffixedProperty;
}

- (NSString *) getTrimKey:(NSString *) key {
    NSUInteger trimLength = [@250 unsignedIntegerValue];
    if([key length] > trimLength) {
        key = [key substringToIndex:trimLength];
    }
    return key;
}

- (void)reset {
    [FS anonymize];
    [RSLogger logDebug:@"[FS anonymize]"];
}

- (void)flush {
    [RSLogger logDebug:@"FullStory Factory doesn't support Flush Call"];
}

BOOL isEmpty(NSObject *value) {
    if (value == nil) {
        return true;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value isEqualToString:@""];
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)value count] == 0;
    }
    if ([value isKindOfClass:[NSMutableDictionary class]]) {
        return [(NSMutableDictionary *)value count] == 0;
    }
    return false;
}

@end

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
    if (self)
    {
        
    }
    return self;
}

- (void) processRudderEvent: (nonnull RSMessage *) message {
    NSString *type = message.type;
    if ([type isEqualToString:@"identify"])
    {
        NSString *userID = !isEmpty(message.userId) ? message.userId : message.anonymousId;
        NSMutableDictionary<NSString*, NSObject*>* traits = [message.context.traits mutableCopy];
        if (traits != nil) {
            [traits removeObjectForKey:@"userId"];
        }
        [FS identify:userID userVars:traits];
    }
    else if ([type isEqualToString:@"track"])
    {
        if (!isEmpty(message.event)) {
            [FS event:[self getTrimKey:[@"screen view " stringByAppendingString:message.event]] properties:message.properties];
            return;
        }
        [RSLogger logDebug:@"Event name is not present in the Track call. Hence, event not sent"];
    }
    else if ([type isEqualToString:@"screen"])
    {
        if (!isEmpty(message.event)) {
            [FS event:[self getTrimKey:[@"screen view " stringByAppendingString:message.event]] properties:message.properties];
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

BOOL isEmpty(NSString *value) {
    return value == nil || value.length == 0;
}

@end

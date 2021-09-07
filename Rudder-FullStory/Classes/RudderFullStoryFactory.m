//
//  RudderFullStoryFactory.m
//  Pods-Rudder-FullStory
//
//  Created by Abhishek Pandey on 07/07/21.
//

#import "RudderFullStoryFactory.h"
#import "RudderFullStoryIntegration.h"

@implementation RudderFullStoryFactory

+ (instancetype)instance {
    static RudderFullStoryFactory *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (nonnull NSString *)key {
    return @"FullStory";
}

- (nonnull id<RSIntegration>)initiate:(nonnull NSDictionary *)config client:(nonnull RSClient *)client rudderConfig:(nonnull RSConfig *)rudderConfig {
    return [[RudderFullStoryIntegration alloc] initWithConfig:config withAnalytics:client];
}


@end

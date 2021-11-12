//
//  RUDDERViewController.m
//  Rudder-FullStory
//
//  Created by Abhishek on 07/07/2021.
//  Copyright (c) 2019 arnab. All rights reserved.
//

#import "RUDDERViewController.h"
#import "Rudder.h"
#import <FullStory/FullStory.h>
@interface RUDDERViewController ()

@end

@implementation RUDDERViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)restart:(id)sender {
    [FS restart];
}
- (IBAction)identify:(id)sender {
    NSMutableDictionary *traits = [[NSMutableDictionary alloc] init];
    [traits setObject:@"Random_Value" forKey:@"Random_Key"];
    [traits setObject:@"support_iOS@rudderstack.com20" forKey:@"email"];
    [traits setObject:@15 forKey:@"age"];
    [traits setObject:@"RudderStack_Name" forKey:@"name"];
    [[RSClient sharedInstance] identify:@"userId_iOS_20" traits:traits];
    
}
- (IBAction)track:(id)sender {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:@"Randeom_Value_1" forKey:@"Random_Key1"];
    [properties setObject:@123 forKey:@"Random_Key2"];
    [properties setObject:@123.23 forKey:@"Random_Key2"];
    [properties setObject:@NO forKey:@"Bool 1"];
    [properties setObject:[NSDate date] forKey:@"date"];
    [properties setObject:[[NSArray alloc] initWithObjects:@"Happy",@"Sad", nil] forKey:@"Array Of Objects"];
    [properties setObject:[[NSArray alloc] initWithObjects:@1, @2, nil] forKey:@"Array_Of_Integers"];
    [[RSClient sharedInstance] track:@"iOS_track_call_3" properties:properties];
}
- (IBAction)screen:(id)sender {
    [[RSClient sharedInstance] screen:@"iOS_screen_call" properties:@{
        @"Random_Key1" : @"Randeom_Value_1"
    }];
}
- (IBAction)reset:(id)sender {
    [[RSClient sharedInstance] reset];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

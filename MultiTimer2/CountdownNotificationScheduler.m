//
//  CountdownNotificationScheduler.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 14/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "CountdownNotificationScheduler.h"

#import "TimerProfile.h"

@implementation CountdownNotificationScheduler

- (instancetype)init
{
    self = [super init];
	
    if (self) {
        _application = [UIApplication sharedApplication];
		_notification = [[UILocalNotification alloc] init];
    }
	
    return self;
}

- (void)scheduleCountdownExpiredNoficationIn:(NSTimeInterval)timeInterval secondsForTimer:(TimerProfile *)timer
{
	[self.notification setUserInfo:@{ @"timerProfileURI" : [timer managedObjectIDAsURI]}];
	[self.notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
	
	[self.application scheduleLocalNotification:[self notification]];
}

- (void)cancelScheduledNotification
{
	[self.application cancelLocalNotification:[self notification]];
}

@end

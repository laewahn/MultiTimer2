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

- (void)scheduleCountdownExpiredNotificationIn:(NSTimeInterval)timeInterval secondsForTimer:(TimerProfile *)timer
{
	NSDictionary* userInfo = @{ @"timerProfileURI" : [timer.managedObjectIDAsURI absoluteString]};
	[self.notification setUserInfo:userInfo];
	[self.notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
	[self.notification setTimeZone:[NSTimeZone localTimeZone]];
	[self.notification setAlertBody:[timer name]];
	[self.notification setAlertAction:@"Show"];
	
	[self.application scheduleLocalNotification:[self notification]];
}

- (void)cancelScheduledNotification
{
	[self.application cancelLocalNotification:[self notification]];
}

@end

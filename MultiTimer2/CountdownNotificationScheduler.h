//
//  CountdownNotificationScheduler.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 14/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TimerProfile;

@interface CountdownNotificationScheduler : NSObject

- (void)scheduleCountdownExpiredNotificationIn:(NSTimeInterval)timeInterval secondsForTimer:(TimerProfile *)timer;
- (void)scheduleCountdownExpiredNotificationOnDate:(NSDate *)theDate forTimer:(TimerProfile *)timer;

- (void)cancelScheduledNotification;

@property(nonatomic, strong) UIApplication* application;
@property(nonatomic, strong) UILocalNotification* notification;

@end

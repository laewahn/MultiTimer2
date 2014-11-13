//
//  TimerController.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 13/11/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "TimerController.h"

#import "TimerProfile.h"
#import "CountdownNotificationScheduler.h"

@implementation TimerController

- (void)startTimer
{
    if ([self.profile remainingTime] == 0) {
        [self.profile setRemainingTime:[self.profile duration]];
    }
    
    [self.profile setRunning:YES];
    
    [self.profile setExpirationDate:[NSDate dateWithTimeIntervalSinceNow:[self.profile remainingTime]]];
    [self.notificationScheduler scheduleCountdownExpiredNotificationIn:[self.profile remainingTime] secondsForTimer:[self profile]];
    [[NSRunLoop mainRunLoop] addTimer:[self countdownTimer] forMode:NSDefaultRunLoopMode];
}

- (void)stopTimer
{
    [self pauseTimer];
    [self.profile setRemainingTime:[self.profile duration]];
}

- (void)pauseTimer
{
    [self stopCountdown];
    
    [self.profile setExpirationDate:nil];
    [self.notificationScheduler cancelScheduledNotification];
    [self setCountdownTimer:nil];
}

- (void)stopCountdown
{
    [self.profile setRunning:NO];
    [self.countdownTimer invalidate];
}

- (NSTimer *)countdownTimer
{
    if (_countdownTimer == nil) {
        _countdownTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateRemainingTime) userInfo:nil repeats:YES];
    }
    
    return _countdownTimer;
}

- (void)updateRemainingTime
{
    [self.profile setRemainingTime:[self.profile remainingTime] - 1];
    if ([self.profile remainingTime] == 0) {
        [self stopCountdown];
    }
    
    [self didChangeValueForKey:@"remainingTime"];
}

- (CountdownNotificationScheduler *)notificationScheduler
{
    if (_notificationScheduler == nil) {
        _notificationScheduler = [[CountdownNotificationScheduler alloc] init];
    }
    
    return _notificationScheduler;
}

@end

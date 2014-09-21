//
//  TimerProfile.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "TimerProfile.h"

#import "CountdownNotificationScheduler.h"

@implementation TimerProfile

@dynamic name;
@dynamic duration;

@synthesize running;
@synthesize remainingTime = _remainingTime;
@synthesize countdownTimer = _countdownTimer;

@synthesize notificationScheduler = _notificationScheduler;

+ (instancetype) createWithName:(NSString *)profileName duration:(NSTimeInterval)profileDuration managedObjectContext:(NSManagedObjectContext *)context
{
	TimerProfile* newProfile = [self createWithManagedObjectContext:context];
	[newProfile setName:profileName];
	[newProfile setDuration:profileDuration];
	[newProfile setRemainingTime:profileDuration];
	
	[context save:nil];
	
	return newProfile;
}

+ (instancetype) createWithManagedObjectContext:(NSManagedObjectContext *)context
{
	return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
}

+ (NSString *)entityName
{
	return @"TimerProfile";
}

- (NSURL *)managedObjectIDAsURI
{
	return [self.objectID URIRepresentation];
}

- (void)awakeFromFetch
{
	[self setRemainingTime:[self duration]];
}

- (CountdownNotificationScheduler *)notificationScheduler
{
	if (_notificationScheduler == nil) {
		_notificationScheduler = [[CountdownNotificationScheduler alloc] init];
	}
	
	return _notificationScheduler;
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
	[self willChangeValueForKey:@"remainingTime"];
	[self setRemainingTime:[self remainingTime] - 1];
	[self didChangeValueForKey:@"remainingTime"];
}

- (void)startCountdown
{
	if ([self remainingTime] == 0) {
		[self setRemainingTime:[self duration]];
	}
	
	[self setRunning:YES];
	
	[self.notificationScheduler scheduleCountdownExpiredNotificationIn:[self remainingTime] secondsForTimer:self];
	[[NSRunLoop mainRunLoop] addTimer:[self countdownTimer] forMode:NSDefaultRunLoopMode];
}

- (void)stopCountdown
{
	[self pauseCountdown];
	[self setRemainingTime:[self duration]];
}

- (void)pauseCountdown
{
	[self setRunning:NO];
	
	[self.notificationScheduler cancelScheduledNotification];
	[self.countdownTimer invalidate];
	[self setCountdownTimer:nil];
}

@end

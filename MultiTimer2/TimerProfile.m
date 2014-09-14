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

@synthesize isRunning;
@synthesize remainingTime = _remainingTime;
@synthesize countdownTimer;

@synthesize notificationScheduler;

+ (instancetype) createWithName:(NSString *)profileName duration:(NSTimeInterval)profileDuration managedObjectContext:(NSManagedObjectContext *)context
{
	TimerProfile* newProfile = [self createWithManagedObjectContext:context];
	[newProfile setName:profileName];
	[newProfile setDuration:profileDuration];
	
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

- (void)awakeFromInsert
{
	[self setUpDefaultValues];
}

- (void)awakeFromFetch
{
	[self setUpDefaultValues];
}

- (void)setUpDefaultValues
{
	[self setRemainingTime:[self duration]];
	[self setNotificationScheduler:[[CountdownNotificationScheduler alloc] init]];

	NSTimer* aCountdownTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateRemainingTime) userInfo:nil repeats:YES];
	[self setCountdownTimer:aCountdownTimer];
}

- (void)updateRemainingTime
{
	[self setRemainingTime:[self remainingTime] - 1];
}

- (void)startCountdown
{
	[self setIsRunning:YES];
	
	[self.notificationScheduler scheduleCountdownExpiredNoficationIn:[self duration] secondsForTimer:self];
	[[NSRunLoop mainRunLoop] addTimer:[self countdownTimer] forMode:NSDefaultRunLoopMode];
}

- (void)stopCountdown
{
	[self pauseCountdown];
	[self setRemainingTime:[self duration]];
}

- (void)pauseCountdown
{
	[self setIsRunning:NO];
	[self.notificationScheduler cancelScheduledNotification];
	[self.countdownTimer invalidate];
}

@end

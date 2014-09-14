//
//  TimerProfile.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "TimerProfile.h"

#import "CountdownNotificationManager.h"

@implementation TimerProfile

@dynamic name;
@dynamic duration;

@synthesize isRunning;
@synthesize remainingTime = _remainingTime;

@synthesize notificationManager;

+ (instancetype) createWithName:(NSString *)profileName duration:(NSTimeInterval)profileDuration managedObjectContext:(NSManagedObjectContext *)context
{
	TimerProfile* newProfile = [self createWithManagedObjectContext:context];
	[newProfile setName:profileName];
	[newProfile setDuration:profileDuration];
	
	[newProfile setNotificationManager:[[CountdownNotificationManager alloc] init]];
	
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

- (void)startCountdown
{
	_remainingTime = [self duration];
	[self setIsRunning:YES];
	
	[self.notificationManager scheduleCountdownExpiredNoficationIn:[self duration] secondsForTimer:self];
}

- (void)stopCountdown
{
	[self setIsRunning:NO];
	
	[self.notificationManager cancelScheduledNotification];
}

@end

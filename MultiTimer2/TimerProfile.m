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
}

- (void)startCountdown
{
	[self setIsRunning:YES];
	
	[self.notificationScheduler scheduleCountdownExpiredNoficationIn:[self duration] secondsForTimer:self];
}

- (void)stopCountdown
{
	[self setIsRunning:NO];
	[self setRemainingTime:[self duration]];
	
	[self.notificationScheduler cancelScheduledNotification];
}

- (void)pauseCountdown
{
	[self setIsRunning:NO];
	
	[self.notificationScheduler cancelScheduledNotification];
}

@end

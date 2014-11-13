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
@dynamic expirationDate;

@synthesize running;
@synthesize remainingTime = _remainingTime;


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


@end

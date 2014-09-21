//
//  TimerProfileStore.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 26/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "TimerProfileStore.h"

#import "TimerProfile.h"

@implementation TimerProfileStore

@synthesize timerProfilesFetchedResultsController = _timerProfilesFetchedResultsController;

- (TimerProfile *)createTimerProfileWithName:(NSString *)name duration:(NSTimeInterval)duration
{
	return [TimerProfile createWithName:name duration:duration managedObjectContext:[self managedObjectContext]];
}

- (NSArray *)fetchTimerProfiles
{
	return [self.managedObjectContext executeFetchRequest:[self fetchRequest]error:nil];
}

- (NSArray *)fetchExpiredTimerProfiles
{
	NSFetchRequest* expiredTimerFetchRequest = [self fetchRequest];
	NSPredicate* expiredTimerPredicate = [NSPredicate predicateWithFormat:@"expirationDate < %@", [NSDate date]];
	[expiredTimerFetchRequest setPredicate:expiredTimerPredicate];
	
	NSError* fetchError;
	NSArray* fetchedProfiles = [self.managedObjectContext executeFetchRequest:expiredTimerFetchRequest error:&fetchError];
	NSAssert(fetchedProfiles != nil, @"Fetching expired profiles failed with error: %@", fetchError);
	
	return fetchedProfiles;
}

- (NSFetchedResultsController *) timerProfilesFetchedResultsController
{
	if (_timerProfilesFetchedResultsController == nil) {
		NSFetchRequest* fetchRequest = [self fetchRequest];
		NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		_timerProfilesFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																			  managedObjectContext:[self managedObjectContext]
																				sectionNameKeyPath:nil
																						 cacheName:nil];

	}
	
	return _timerProfilesFetchedResultsController;
}

- (NSFetchRequest *)fetchRequest
{
	return [NSFetchRequest fetchRequestWithEntityName:@"TimerProfile"];
}

@end

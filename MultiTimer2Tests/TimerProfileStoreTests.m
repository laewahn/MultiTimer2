//
//  TimerProfileStoreTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 26/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTest+CoreDataTestStack.h"

#import "TimerProfileStore.h"
#import "TimerProfile.h"

@interface TimerProfileStoreTests : XCTestCase {
	NSManagedObjectContext* someContext;
	TimerProfileStore* testStore;
	
	NSString* someProfileName;
	NSTimeInterval someProfileDuration;
}
@end


@implementation TimerProfileStoreTests

- (void)setUp
{
	someProfileName = @"TestTest";
	someProfileDuration = 66;

	someContext = [self managedObjectTestContext];
	testStore = [[TimerProfileStore alloc] init];
	[testStore setManagedObjectContext:someContext];
}

- (void)testStoreCanHaveManagedObjectContext
{
	[testStore setManagedObjectContext:someContext];
	XCTAssertEqualObjects([testStore managedObjectContext], someContext);
}

- (void)testStoreCanCreateTimerProfiles
{
	TimerProfile* newProfile = [testStore createTimerProfileWithName:someProfileName duration:someProfileDuration];
	
	XCTAssertNotNil(newProfile);
	XCTAssertEqualObjects([newProfile name], someProfileName);
	XCTAssertEqual([newProfile duration], someProfileDuration);
}

- (void)testStoreFetchesAllTimerProfiles
{
	[testStore setManagedObjectContext:[self managedObjectTestContextWithTimerProfileNamed:someProfileName duration:someProfileDuration]];
	
	NSSet* fetchedItems = [testStore fetchTimerProfiles];
	XCTAssertEqual([fetchedItems count], 1);
	
	[self assertObject:[fetchedItems anyObject] isTimerProfileWithName:someProfileName duration:someProfileDuration];
}

- (void)testStoreHasFetchedResultsController
{
	NSFetchedResultsController* frc = [testStore timerProfilesFetchedResultsController];
	
	XCTAssertNotNil(frc);
}

- (void)testFetchedResultsControllerFetchesTimerProfiles
{
    [testStore setManagedObjectContext:[self managedObjectTestContextWithTimerProfileNamed:someProfileName duration:someProfileDuration]];
    
	NSFetchedResultsController* frc = [testStore timerProfilesFetchedResultsController];
	NSError* fetchError;
	BOOL fetchSuccess = [frc performFetch:&fetchError];
	
	XCTAssertTrue(fetchSuccess, @"Fetch failed with error: %@", fetchError);
	XCTAssertEqual([frc.fetchedObjects count], 1);

	[self assertObject:[frc.fetchedObjects firstObject] isTimerProfileWithName:someProfileName duration:someProfileDuration];
}

- (void)assertObject:(id)someObject isTimerProfileWithName:(NSString *)name duration:(NSTimeInterval)duration
{
	XCTAssertTrue([someObject isKindOfClass:[TimerProfile class]]);
	XCTAssertEqualObjects([someObject name], name);
	XCTAssertEqual([(TimerProfile *)someObject duration], duration);
}

- (void)testFetchedResultsControllerIsInitializedLazily
{
    [testStore setManagedObjectContext:someContext];
	
	NSFetchedResultsController* firstFrc = [testStore timerProfilesFetchedResultsController];
	NSFetchedResultsController* secondFrc = [testStore timerProfilesFetchedResultsController];
	
	XCTAssertEqualObjects(firstFrc, secondFrc);
}

- (void)testOnTimerProfileStore_ItCanFetchExpiredTimers
{
    TimerProfile* expiredProfile = [testStore createTimerProfileWithName:@"Expired" duration:-10];
	TimerProfile* anotherExpiredProfile = [testStore createTimerProfileWithName:@"Also expired" duration:-15];
	TimerProfile* notExpiredProfile = [testStore createTimerProfileWithName:@"Not expired" duration:10];
	NSArray* allTimers = @[expiredProfile, notExpiredProfile, anotherExpiredProfile];
	for (TimerProfile* timer in allTimers) {
		[timer startCountdown];
	}
	
	NSSet* fetchedExpiredTimers = [testStore fetchExpiredTimerProfiles];

	NSSet* expiredTimers = [NSSet setWithArray:@[expiredProfile, anotherExpiredProfile]];
	XCTAssertNotNil(fetchedExpiredTimers);
	XCTAssertEqualObjects(fetchedExpiredTimers, expiredTimers);
	XCTAssertFalse([fetchedExpiredTimers containsObject:notExpiredProfile]);
	
	for (TimerProfile* timer in allTimers) {
		[timer stopCountdown];
	}
}

@end

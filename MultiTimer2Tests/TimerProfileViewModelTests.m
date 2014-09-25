//
//  TimerProfileViewModelTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "XCTest+CoreDataTestStack.h"

#import "TimerProfileViewModel.h"
#import "TimerProfile.h"

#import "CountdownNotificationScheduler.h"

@interface TimerProfileViewModelTests : XCTestCase {
	TimerProfileViewModel* testViewModel;
	
	TimerProfile* mockProfile;
	NSManagedObjectContext* context;
}

@end

@implementation TimerProfileViewModelTests

# pragma mark -
# pragma mark SetUp & TearDown

- (void)setUp
{
	context = [self managedObjectTestContext];
	mockProfile = OCMClassMock([TimerProfile class]);
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:[self someTimerProfile]];
}


# pragma mark -
# pragma mark Initialization Tests

- (void)testTimerProfileViewModelCanBeInitializedWithTimerProfile
{
	TimerProfile* testProfile = [self someTimerProfile];
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:testProfile];
	
	XCTAssertNotNil(testViewModel);
	XCTAssertEqualObjects([testViewModel timerProfile], testProfile, @"Should have the TimerProfile");
}

- (void)testOnViewModelInitialization_ItAddsItselfAsObserverForTheTimerProfilesState
{
	[[[(id)mockProfile expect] ignoringNonObjectArgs] addObserver:OCMOCK_ANY forKeyPath:@"remainingTime" options:0 context:[OCMArg anyPointer]];
	[[[(id)mockProfile expect] ignoringNonObjectArgs] addObserver:OCMOCK_ANY forKeyPath:@"running" options:0 context:[OCMArg anyPointer]];
	
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:mockProfile];
	
	[(id)mockProfile verify];
}

- (void)testOnViewModel_WhenTheTimerProfileCountdownIsRunning_ItShowsTheRemainingTime
{
	TimerProfile* someProfile = [self someTimerProfile];
	[someProfile setRemainingTime:7];
	[someProfile setRunning:YES];
	
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:someProfile];
	
	XCTAssertEqualObjects([testViewModel duration], @"00:07");
}


# pragma mark -
# pragma mark Property Tests

- (void)testTimerProfileViewModelReturnsProfileName
{
	NSString* timerProfileName = @"Test";
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:[self someTimerProfileWithName:timerProfileName]];
	
	XCTAssertEqualObjects([testViewModel name], timerProfileName, @"Should return the name");
}

- (void)testTimerProfileViewModelReturnsCorrectlyFormattedDurationLessThan60Seconds
{
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:[self someTimerProfileWithDuration:34]];
	
	XCTAssertEqualObjects([testViewModel duration], @"00:34", @"Duration should be formatted with leading zeros");
}

- (void)testTimerProfileViewModelReturnsCorretlyFormattedDurationForOneMinute
{
    testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:[self someTimerProfileWithDuration:60]];
	
	XCTAssertEqualObjects([testViewModel duration], @"01:00");
}

- (void)testTimerProfileViewModelReturnsCorrectlyFormattedDurationForMoreThanOneMinute
{
    testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:[self someTimerProfileWithDuration:133]];
	
	XCTAssertEqualObjects([testViewModel duration], @"02:13");
}

- (void)testTimerProfileViewModelReturnsCorrectlyformattedDurationforMoreThanOneHour
{
    testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:[self someTimerProfileWithDuration:3660]];
	
	XCTAssertEqualObjects([testViewModel duration], @"1:01:00");
}

- (void)testOnViewModel_ItHasDifferentStates
{
	XCTAssertNoThrow([testViewModel countdownState]);
}


# pragma mark -
# pragma mark Public Methods Tests

- (void)testTimerCanBeStarted
{
    testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:[self someTimerProfile]];
	
	XCTAssertNoThrow([testViewModel startCountdown]);
}

- (void)testWhenStartCountdownIsCalled_itStartsTheCountdown
{
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:mockProfile];
	[testViewModel startCountdown];
	
	OCMVerify([mockProfile startTimer]);
}

- (void)testWhenPauseCountdownIsCalled_ItPausesTheCountdown
{
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:mockProfile];
	[testViewModel pauseCountdown];
	
	OCMVerify([mockProfile pauseTimer]);
}

- (void)testWhenStopCountdownIsCalled_itStopsTheCountdown
{
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:mockProfile];
	[testViewModel stopCountdown];
	
	OCMVerify([mockProfile stopTimer]);
}

- (void)testOnViewModelCreationWithTimerProfileNotRunningAndRemainingTimeIsDuration_TheStateIsStopped
{
	TimerProfile* someTimerProfile = [self someTimerProfile];
	[someTimerProfile setRemainingTime:[someTimerProfile duration]];
	[someTimerProfile setRunning:NO];
	
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:someTimerProfile];
	
	XCTAssertEqual([testViewModel countdownState], TimerProfileViewModelStateStopped);
}

- (void)testOnViewModelCreationWithTimerProfileRunning_TheStateIsRunning
{
	TimerProfile* someTimerProfile = [self someTimerProfile];
	[someTimerProfile setRemainingTime:[someTimerProfile duration] - 1];
	[someTimerProfile setRunning:YES];
	
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:someTimerProfile];
	
	XCTAssertEqual([testViewModel countdownState], TimerProfileViewModelStateRunning);
}

- (void)testOnViewModelCreationWithTimerProfileNotRunningAndRemainingTimeNotEqualDuration_TheStateIsPaused
{
	TimerProfile* someTimerProfile = [self someTimerProfile];
	[someTimerProfile setRemainingTime:[someTimerProfile duration] - 1];
	[someTimerProfile setRunning:NO];
	
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:someTimerProfile];
	
	XCTAssertEqual([testViewModel countdownState], TimerProfileViewModelStatePaused);
}

- (void)testOnViewModelCreation_WhenRemainingTimeIsZero_TheStateIsExpired
{
	TimerProfile* someProfile = [self someTimerProfile];
	[someProfile setRemainingTime:0];
	
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:someProfile];
	
	XCTAssertEqual([testViewModel countdownState], TimerProfileViewModelStateExpired);
}


# pragma mark -
# pragma mark Remaining Time Update Tests

- (void)testOnViewModel_ItHandlesKVOCalls
{
	NSDictionary* modelChange = @{
								  NSKeyValueChangeNewKey : @1
								  };
	
    XCTAssertNoThrow([testViewModel observeValueForKeyPath:@"remainingTime" ofObject:testViewModel change:modelChange context:TimerProfileRemainingTimeContext]);
}


# pragma mark -
# pragma mark Fixtures generation

- (TimerProfile *)someTimerProfile
{
	return [self someTimerProfileWithName:@"Test"];
}

- (TimerProfile *)someTimerProfileWithName:(NSString *)name
{
	TimerProfile* newTimer = [TimerProfile createWithName:name duration:10 managedObjectContext:context];
	[newTimer setNotificationScheduler:OCMClassMock([CountdownNotificationScheduler class])];
	return newTimer;
}

- (TimerProfile *)someTimerProfileWithDuration:(NSTimeInterval)duration
{
	TimerProfile* newTimer = [TimerProfile createWithName:@"Test" duration:duration managedObjectContext:context];
	[newTimer setNotificationScheduler:OCMClassMock([CountdownNotificationScheduler class])];
	return newTimer;
}

@end

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

@interface TimerProfileViewModelTests : XCTestCase {
	TimerProfileViewModel* testViewModel;
	
	TimerProfile* mockProfile;
}

@end

@implementation TimerProfileViewModelTests

- (void)setUp
{
	mockProfile = OCMClassMock([TimerProfile class]);
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:mockProfile];
}

- (void)testTimerProfileViewModelCanBeInitializedWithTimerProfile
{
	TimerProfile* testProfile = [self someTimerProfile];
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:testProfile];
	
	XCTAssertNotNil(testViewModel);
	XCTAssertEqualObjects([testViewModel timerProfile], testProfile, @"Should have the TimerProfile");
}

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

- (void)testTimerCanBeStarted
{
    testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:[self someTimerProfile]];
	
	XCTAssertNoThrow([testViewModel startCountdown]);
}

- (void)testWhenStartCountdownIsCalled_itStartsTheCountdown
{
	[testViewModel startCountdown];
	
	OCMVerify([mockProfile startCountdown]);
}

- (void)testWhenStopCountdownIsCalled_itStopsTheCountdown
{
	[testViewModel stopCountdown];
	
	OCMVerify([mockProfile stopCountdown]);
}

- (void)testOnViewModel_WhenTheTimerProfileCountdownIsRunning_ItShowsTheRemainingTime
{
	TimerProfile* someProfile = [self someTimerProfile];
	[someProfile setRemainingTime:7];
	[someProfile setIsRunning:YES];
	
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:someProfile];
	
	XCTAssertEqualObjects([testViewModel duration], @"00:07");
}

- (void)testOnViewModelInitialization_ItAddsItselfAsObserverForTheTimerProfilesRemainingTime
{
	[[[(id)mockProfile expect] ignoringNonObjectArgs] addObserver:OCMOCK_ANY forKeyPath:@"remainingTime" options:0 context:[OCMArg anyPointer]];
    
	testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:mockProfile];
	
	[(id)mockProfile verify];
}

- (void)testOnViewModel_ItHandlesKVOCalls
{
	NSDictionary* modelChange = @{
								  NSKeyValueChangeNewKey : @1
								  };
	
    XCTAssertNoThrow([testViewModel observeValueForKeyPath:@"remainingTime" ofObject:testViewModel change:modelChange context:TimerProfileRemainingTimeContext]);
}


# pragma mark Fixtures generation

- (TimerProfile *)someTimerProfile
{
	return [self someTimerProfileWithName:@"Test"];
}

- (TimerProfile *)someTimerProfileWithName:(NSString *)name
{
	return [TimerProfile createWithName:name duration:10 managedObjectContext:[self managedObjectTestContext]];
}

- (TimerProfile *)someTimerProfileWithDuration:(NSTimeInterval)duration
{
	return [TimerProfile createWithName:@"Test" duration:duration managedObjectContext:[self managedObjectTestContext]];
}

@end

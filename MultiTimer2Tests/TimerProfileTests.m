//
//  TimerProfileTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "XCTest+CoreDataTestStack.h"

#import "TimerProfile.h"
#import "CountdownNotificationScheduler.h"

@interface TimerProfileTests : XCTestCase {
	NSManagedObjectContext* someManagedObjectContext;
	TimerProfile* testProfile;
	CountdownNotificationScheduler* mockNotificationScheduler;
	
	NSString* someProfileName;
	NSTimeInterval someProfileDuration;
}

@end

@implementation TimerProfileTests

- (void)setUp
{
	someManagedObjectContext = [self managedObjectTestContext];
	
	someProfileName = @"Test";
	someProfileDuration = 10;
	
	testProfile = [TimerProfile createWithName:someProfileName duration:someProfileDuration managedObjectContext:someManagedObjectContext];
	
	mockNotificationScheduler = OCMClassMock([CountdownNotificationScheduler class]);
	[testProfile setNotificationScheduler:mockNotificationScheduler];
}

- (void)testTimerProfileCanBeCreatedWithNameDurationAndManagedObjectContext
{
	testProfile = [TimerProfile createWithName:someProfileName duration:someProfileDuration managedObjectContext:someManagedObjectContext];

	XCTAssertNotNil(testProfile);
	XCTAssertEqualObjects([testProfile managedObjectContext], someManagedObjectContext, @"Should know the managed object context.");
	XCTAssertEqualObjects([testProfile name], someProfileName, @"Name should be set.");
	XCTAssertEqual([testProfile duration], someProfileDuration, @"Duration should be set.");
}

- (void)testOnTimerProfileCreation_ItHasACountdownNotificationScheduler
{
	testProfile = [TimerProfile createWithName:someProfileName duration:someProfileDuration managedObjectContext:someManagedObjectContext];

    XCTAssertNotNil([testProfile notificationScheduler]);
}

- (void)testOnTimerProfileFetch_TheRemainingTimeIsSetToTheProfilesTime
{
	[testProfile awakeFromFetch];
	NSTimeInterval initialTime = someProfileDuration;
	
	XCTAssertEqual([testProfile remainingTime], initialTime);
}

- (void)testOnTimerProfileWithRunningCountdown_WhenStartCountdownIsCalled_TheIsRunningPropertyIsSetToTrue
{
	[testProfile startCountdown];
	
	XCTAssertTrue([testProfile isRunning]);
}

- (void)testOnTimerProfileWithRunningCountdown_WhenStopCountdownIsCalled_TheIsRunningPropertyIsSetToFalseAndTheRemainingTimeIsReset
{
	[testProfile startCountdown];
	[testProfile setRemainingTime:7];
    
	[testProfile stopCountdown];
	
	XCTAssertFalse([testProfile isRunning]);
	XCTAssertEqual([testProfile remainingTime], [testProfile duration]);
}

- (void)testOnTimerProfileWithRunningCountdown_WhenCountdownIsPaused_TheRunningPropertyIsSetToTrue
{
	[testProfile startCountdown];
	
	[testProfile pauseCountdown];
	
	XCTAssertFalse([testProfile isRunning]);
}

- (void)testOnTimerProfileWithPausedCountdown_WhenCountdownIsStarted_TheRemainingTimeIsSetToTheTimeWhenItWasPaused
{
    [testProfile startCountdown];
	[testProfile setRemainingTime:3];
	[testProfile pauseCountdown];
	
	NSTimeInterval timeAfterPause = [testProfile remainingTime];
	[testProfile startCountdown];
	
	XCTAssertEqual([testProfile remainingTime], timeAfterPause);
}

- (void)testOnTimerProfile_WhenStartCountdownIsCalled_ItSchedulesANotificationForTheDateWhenTheCountdownFinishes
{
	[testProfile startCountdown];
	
	OCMVerify([mockNotificationScheduler scheduleCountdownExpiredNoficationIn:[testProfile duration] secondsForTimer:testProfile]);
}

- (void)testOnTimerProfile_WhenStopCountdownIsCalled_ItCancelsItsNotification
{
	[testProfile stopCountdown];
	
	OCMVerify([mockNotificationScheduler cancelScheduledNotification]);
}

- (void)testOnTimerProfile_WhenPausingTheCountdown_ItCancelsItsNotification
{
    [testProfile pauseCountdown];
	
	OCMVerify([mockNotificationScheduler cancelScheduledNotification]);
}


@end

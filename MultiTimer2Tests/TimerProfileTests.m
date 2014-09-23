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
	[testProfile startTimer];
	
	XCTAssertTrue([testProfile isRunning]);
}

- (void)testOnTimerProfileWithRunningCountdown_WhenStopCountdownIsCalled_TheIsRunningPropertyIsSetToFalseAndTheRemainingTimeIsReset
{
	[testProfile startTimer];
	[testProfile setRemainingTime:7];
    
	[testProfile stopTimer];
	
	XCTAssertFalse([testProfile isRunning]);
	XCTAssertEqual([testProfile remainingTime], [testProfile duration]);
}

- (void)testOnTimerProfileWithRunningCountdown_WhenCountdownIsPaused_TheRunningPropertyIsSetToTrue
{
	[testProfile startTimer];
	
	[testProfile pauseTimer];
	
	XCTAssertFalse([testProfile isRunning]);
}

- (void)testOnTimerProfileWithPausedCountdown_WhenCountdownIsStarted_TheRemainingTimeIsSetToTheTimeWhenItWasPaused
{
    [testProfile startTimer];
	[testProfile setRemainingTime:3];
	[testProfile pauseTimer];
	
	NSTimeInterval timeAfterPause = [testProfile remainingTime];
	[testProfile startTimer];
	
	XCTAssertEqual([testProfile remainingTime], timeAfterPause);
}

- (void)testOnTimerProfile_WhenCountdownIsStarted_ItStoresTheExpirationTime
{
	[testProfile startTimer];
	
	NSDate* countdownExpirationTime = [testProfile expirationDate];
	XCTAssertEqualWithAccuracy([countdownExpirationTime timeIntervalSinceNow], [testProfile duration], 0.001);
}

- (void)testOnTimerProfile_CountdownIsStarted_ItSchedulesANotificationForTheDateWhenTheCountdownFinishes
{
	[testProfile startTimer];
	
	OCMVerify([mockNotificationScheduler scheduleCountdownExpiredNotificationIn:[testProfile duration] secondsForTimer:testProfile]);
}

- (void)testOnTimerProfileWithRunningCountdown_WhenCountdownPausedAndStartedAgain_ItScheduledANotificationForTheRemainingTime
{
    [testProfile startTimer];
	[testProfile setRemainingTime:[testProfile remainingTime] - 1];

	[testProfile pauseTimer];
	[testProfile startTimer];
	
	OCMVerify([mockNotificationScheduler scheduleCountdownExpiredNotificationIn:[testProfile remainingTime] secondsForTimer:testProfile]);
}

- (void)testOnTimerProfileWithRunningCountdown_WhenCountdownIsPausedAndStartedAgain_ItStoresTheUpdatedExpirationTime
{
	[testProfile startTimer];
	[testProfile setRemainingTime:[testProfile remainingTime] -1];
	
	[testProfile pauseTimer];
	[testProfile startTimer];
	
	NSDate* countdownExpirationTime = [testProfile expirationDate];
	XCTAssertEqualWithAccuracy([countdownExpirationTime timeIntervalSinceNow], [testProfile remainingTime], 0.001);
}


- (void)testOnTimerProfile_WhenStopCountdownIsCalled_ItCancelsItsNotification
{
	[testProfile stopTimer];
	
	OCMVerify([mockNotificationScheduler cancelScheduledNotification]);
}

- (void)testOnTimerProfileWithRunningCountdown_WhenCountIsStopped_ItRemovesTheExpirationDate
{
    [testProfile startTimer];
	
	[testProfile stopTimer];
	
	XCTAssertNil([testProfile expirationDate]);
}

- (void)testOnTimerProfile_WhenPausingTheCountdown_ItCancelsItsNotification
{
    [testProfile pauseTimer];
	
	OCMVerify([mockNotificationScheduler cancelScheduledNotification]);
}

- (void)testOnTimerProfileWithRunningCountdown_WhenPausingCountdown_ItRemovesTheExpirationDate
{
    [testProfile startTimer];
	
	[testProfile pauseTimer];
	
	XCTAssertNil([testProfile expirationDate]);
}

- (void)testOnTimerProfileCreation_ItHasACountdownTimer
{
    XCTAssertNotNil([testProfile countdownTimer]);
	XCTAssertEqual([testProfile.countdownTimer timeInterval], 1);
}

- (void)testOnTimerProfile_WhenTheCountdownTimerFires_TheRemainingTimeDecreasesByOne
{
	NSTimeInterval remainingTimeBeforeCountdownInvocation = [testProfile remainingTime];
    [testProfile.countdownTimer fire];
	
	XCTAssertEqual([testProfile remainingTime], remainingTimeBeforeCountdownInvocation - 1);
}

- (void)testOnTimerProfile_WhenTheCountdownReachesZero_ItPausesTheCountdownButDoesNotCancelTheNotification
{
	[testProfile setRunning:YES];
    [testProfile setRemainingTime:1];
	[[(id)mockNotificationScheduler reject] cancelScheduledNotification];
	
	[testProfile.countdownTimer fire];
	
	XCTAssertFalse([testProfile isRunning]);
	XCTAssertFalse([testProfile.countdownTimer isValid]);
	OCMVerifyAll((id)mockNotificationScheduler);
}

- (void)testOnTimerProfile_WhenStartingTheCountdown_ItAddsTheCountdownToTheRunloop
{
    NSRunLoop* partialMainRunloop = OCMPartialMock([NSRunLoop mainRunLoop]);
	
	[testProfile startTimer];
	
	OCMVerify([partialMainRunloop addTimer:[testProfile countdownTimer] forMode:NSDefaultRunLoopMode]);
}

- (void)testOnTimerProfile_WhenStoppingTheCountdown_ItInvalidatesTheCountdown {
	
    NSTimer* mockTimer = OCMClassMock([NSTimer class]);
	[testProfile setCountdownTimer:mockTimer];
	
	[testProfile stopTimer];
	
	OCMVerify([mockTimer invalidate]);
}

- (void)testOnTimerProfile_WhenPausingTheCountdown_ItInvalidatesTheCountdown
{
    NSTimer* mockTimer = OCMClassMock([NSTimer class]);
	[testProfile setCountdownTimer:mockTimer];
	
	[testProfile pauseTimer];
	
	OCMVerify([mockTimer invalidate]);
}


@end

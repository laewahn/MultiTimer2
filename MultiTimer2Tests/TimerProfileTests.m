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
#import "CountdownNotificationManager.h"

@interface TimerProfileTests : XCTestCase {
	NSManagedObjectContext* someManagedObjectContext;
	TimerProfile* testProfile;
	
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
}

- (void)testTimerProfileCanBeCreatedWithNameDurationAndManagedObjectContext
{
	XCTAssertNotNil(testProfile);
	XCTAssertEqualObjects([testProfile managedObjectContext], someManagedObjectContext, @"Should know the managed object context.");
	XCTAssertEqualObjects([testProfile name], someProfileName, @"Name should be set.");
	XCTAssertEqual([testProfile duration], someProfileDuration, @"Duration should be set.");
}

- (void)testOnTimerProfile_WhenStartCountdownIsCalled_TheRemainingTimeIsSetToTheProfilesTime
{
	NSTimeInterval initialTime = 300;
    testProfile = [TimerProfile createWithName:someProfileName duration:initialTime managedObjectContext:someManagedObjectContext];
	
	[testProfile startCountdown];
	
	XCTAssertEqual([testProfile remainingTime], initialTime);
}

- (void)testOnTimerProfileWithRunningCountdown_WhenStartCountdownIsCalled_TheIsRunningPropertyIsSetToTrue
{
	[testProfile startCountdown];
	
	XCTAssertTrue([testProfile isRunning]);
}

- (void)testOnTimerProfile_WhenStopCountdownIsCalled_TheIsRunningPropertyIsSetToFalse
{
	[testProfile startCountdown];
    
	[testProfile stopCountdown];
	
	XCTAssertFalse([testProfile isRunning]);
}

- (void)testOnTimerProfileCreation_ItHasACountdownNotificationManager
{
    XCTAssertNotNil([testProfile notificationManager]);
}

- (void)testOnTimerProfile_WhenStartCountdownIsCalled_ItSchedulesANotificationForTheDateWhenTheCountdownFinishes
{
	CountdownNotificationManager* mockNotificationManager = OCMClassMock([CountdownNotificationManager class]);
	[testProfile setNotificationManager:mockNotificationManager];
		
	[testProfile startCountdown];
	
	OCMVerify([mockNotificationManager scheduleCountdownExpiredNoficationIn:[testProfile duration] secondsForTimer:testProfile]);
}

- (void)testOnTimerProfile_WhenStopCountdownIsCalled_ItCancelsItsNotification
{
    CountdownNotificationManager* mockNotificationManager = OCMClassMock([CountdownNotificationManager class]);
	[testProfile setNotificationManager:mockNotificationManager];
	
	[testProfile stopCountdown];
	
	OCMVerify([mockNotificationManager cancelScheduledNotification]);
}

@end

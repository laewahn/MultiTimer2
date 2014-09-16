//
//  CountdownNotificationManagerTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 14/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XCTest+CoreDataTestStack.h"

#import "CountdownNotificationScheduler.h"


@interface CountdownNotificationSchedulerDefaults : XCTestCase
@end

@implementation CountdownNotificationSchedulerDefaults

- (void)testOnCountdownNotificationSchedulerCreation_ItHasTheSharedApplication
{
    CountdownNotificationScheduler* testScheduler = [[CountdownNotificationScheduler alloc] init];
	XCTAssertEqual([testScheduler application], [UIApplication sharedApplication]);
}

- (void)testOnCountdownNotificationSchedulerCreation_itHasSomeLocalNotification
{
    CountdownNotificationScheduler* testScheduler = [[CountdownNotificationScheduler alloc] init];
	XCTAssertNotNil([testScheduler notification]);
}

@end


#import "TimerProfile.h"

@interface CountdownNotificationSchedulerTests : XCTestCase{
	CountdownNotificationScheduler* testScheduler;

	TimerProfile* stubProfile;
	NSManagedObjectContext* testContext;
	UIApplication* mockApplication;
}
@end

@implementation CountdownNotificationSchedulerTests

- (void)setUp
{
	testScheduler = [[CountdownNotificationScheduler alloc] init];

	mockApplication = OCMClassMock([UIApplication class]);
	[testScheduler setApplication:mockApplication];
	
	testContext = [self managedObjectTestContext];
	stubProfile = [TimerProfile createWithName:@"SomeProfile" duration:10 managedObjectContext:testContext];
}

- (void)testOnCountdownNotificationScheduler_ItCanKnowTheApplication
{
	[testScheduler setApplication:[UIApplication sharedApplication]];
	XCTAssertEqual([testScheduler application], [UIApplication sharedApplication]);
}

- (void)testOnCountdownNotificationScheduler_ItCanHaveSomeLocalNotification
{
	UILocalNotification* someNotification = [[UILocalNotification alloc] init];
	[testScheduler setNotification:someNotification];
	XCTAssertEqualObjects([testScheduler notification], someNotification);
}

- (void)testOnCountdownNotificationScheduler_WhenSchedulingANotification_ItsSchedulesANotificationOnTheApplication
{
	[testScheduler scheduleCountdownExpiredNoficationIn:10 secondsForTimer:stubProfile];
	
	OCMVerify([mockApplication scheduleLocalNotification:[testScheduler notification]]);
}

- (void)testOnCountdownNotificationSchedulerWithScheduledNotification_TheNotificationIsScheduledForTheTimerProfile
{
	NSDate* dateWhenCalled = [NSDate date];
	[testScheduler scheduleCountdownExpiredNoficationIn:10 secondsForTimer:stubProfile];
	
	UILocalNotification* scheduledNotification = [testScheduler notification];
	
	XCTAssertEqualObjects([scheduledNotification userInfo][@"timerProfileURI"], [stubProfile.managedObjectIDAsURI absoluteString]);
	XCTAssertEqualObjects([scheduledNotification timeZone], [NSTimeZone localTimeZone]);
	XCTAssertEqualObjects([scheduledNotification alertBody], [stubProfile name]);
	XCTAssertEqualObjects([scheduledNotification alertAction], @"Show");
	XCTAssertEqualWithAccuracy([scheduledNotification.fireDate timeIntervalSinceDate:dateWhenCalled], 10, 0.001);
	XCTAssertNotNil([scheduledNotification soundName]);
}

- (void)testOnCountdownNotificationSchedulerWithScheduledNotification_WhenCancellingTheNotification_TheNotificationIsRemovedFromTheApplication
{
	[testScheduler scheduleCountdownExpiredNoficationIn:10 secondsForTimer:stubProfile];
	
	[testScheduler cancelScheduledNotification];
	
	OCMVerify([mockApplication cancelLocalNotification:[testScheduler notification]]);
}

- (void)testOnCountdownNotificationSchedulerWithoutScheduledNotification_WhenCancellingTheNotification_ItDoesNotCrash
{
    XCTAssertNoThrow([testScheduler cancelScheduledNotification]);
}

@end

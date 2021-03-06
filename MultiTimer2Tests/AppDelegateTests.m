//
//  AppDelegateTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 01/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "XCTest+CoreDataTestStack.h"

#import "AppDelegate.h"

#import "TimerOverviewViewController.h"
#import "TimerProfileStore.h"
#import "TimerProfile.h"
#import "TimerAlert.h"

@interface AppDelegateTests : XCTestCase {
	UILocalNotification* someNotification;
	AppDelegate* testAppDelegate;
	
	NSManagedObjectContext* testContext;
	TimerProfile* someProfile;
}

@end

@implementation AppDelegateTests

# pragma mark -
# pragma mark Setup & TearDown

- (void)setUp
{
	testAppDelegate = [[AppDelegate alloc] init];
	someNotification = [[UILocalNotification alloc] init];
	
	testContext = [self managedObjectTestContext];
	[testAppDelegate setManagedObjectContext:testContext];
	
	someProfile = [TimerProfile createWithName:@"Some Timer" duration:10 managedObjectContext:testContext];
	[someNotification setUserInfo:@{ @"timerProfileURI" : [someProfile.managedObjectIDAsURI absoluteString]}];
}


# pragma mark -
# pragma mark CoreData Setup Tests

- (void)testAppDelegateSetsUpCoreDataStack
{
	[testAppDelegate setManagedObjectContext:nil];
	NSManagedObjectContext* appContext = [testAppDelegate managedObjectContext];
	
	XCTAssertNotNil(appContext);
	XCTAssertEqual([appContext concurrencyType], NSMainQueueConcurrencyType);
	XCTAssertNotNil([appContext persistentStoreCoordinator]);
	XCTAssertNotEqual([appContext.persistentStoreCoordinator.persistentStores count], 0);
}

- (void)testOnAppdelegate_ItHasSomeTimerProfileStore
{
    XCTAssertNotNil([testAppDelegate timerProfileStore]);
	XCTAssertEqualObjects([testAppDelegate.timerProfileStore managedObjectContext], [testAppDelegate managedObjectContext]);
}


# pragma mark -
# pragma mark Notification Handling Tests

- (void)testOnAppDelegate_WhenReceivingLocalNotification_ItFindsTheTimerProfileAndHandlesIt
{
	AppDelegate* partialAppDelegate = OCMPartialMock(testAppDelegate);

	[testAppDelegate application:[UIApplication sharedApplication] didReceiveLocalNotification:someNotification];
	
	OCMVerify([partialAppDelegate handleExpiredTimer:someProfile]);
}

- (void)testOnAppDelegate_WhenReceivingLocalNotification_ItPostsAnAlertForTheNotification
{
	XCTAssertNotNil([testAppDelegate timerAlert]);
	
	TimerAlert* mockAlert = OCMClassMock([TimerAlert class]);
	[testAppDelegate setTimerAlert:mockAlert];
	
	[testAppDelegate application:[UIApplication sharedApplication] didReceiveLocalNotification:someNotification];
	
	OCMVerify([mockAlert setTitle:@"Some Timer"]);
	OCMVerify([mockAlert show]);
	OCMVerify([mockAlert setTimer:someProfile]);
}

- (void)testOnAppDelegate_WhenTheAlertIsDismissed_ItResetsTheCountdown
{
    XCTAssertTrue([testAppDelegate conformsToProtocol:@protocol(UIAlertViewDelegate)]);
	
	TimerProfile* mockProfile = OCMClassMock([TimerProfile class]);
	TimerAlert* alert = [[TimerAlert alloc] init];
	[alert setTimer:mockProfile];
	
	[testAppDelegate alertView:alert clickedButtonAtIndex:0];
	
	OCMVerify([mockProfile stopTimer]);
}


# pragma mark -
# pragma mark Application Lifecycle Tests

- (void)testOnAppDelegate_WhenAppBecomesActive_ItStopsAllExpiredTimers
{
	TimerProfile* mockExpiredProfile = OCMClassMock([TimerProfile class]);
    TimerProfileStore* stubStore = OCMClassMock([TimerProfileStore class]);
	OCMStub([stubStore fetchExpiredTimerProfiles]).andReturn([NSSet setWithObject:mockExpiredProfile]);
	[testAppDelegate setTimerProfileStore:stubStore];

	[testAppDelegate applicationDidBecomeActive:nil];
	
	OCMVerify([mockExpiredProfile stopTimer]);
}

- (void)testOnAppDelegate_WhenAppBecomesActive_ItUpdatesAllRunningTimers
{
    TimerProfile* runningTimer = [[testAppDelegate timerProfileStore] createTimerProfileWithName:@"Running" duration:10];
	[runningTimer startTimer];
	[runningTimer setRemainingTime:20];

	TimerProfile* notRunningTimer = [[testAppDelegate timerProfileStore] createTimerProfileWithName:@"Not running" duration:30];
	[notRunningTimer startTimer];
	[notRunningTimer pauseTimer];
	
	[testAppDelegate applicationDidBecomeActive:nil];
	
	XCTAssertEqualWithAccuracy([runningTimer remainingTime], 10, 0.5);
	XCTAssertEqual([notRunningTimer remainingTime], 30);
	
	[runningTimer stopTimer];
}

@end

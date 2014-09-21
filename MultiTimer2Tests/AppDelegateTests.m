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


@interface AppDelegateTests : XCTestCase {
	UILocalNotification* someNotification;
	AppDelegate* testAppDelegate;
}

@end

@implementation AppDelegateTests

- (void)setUp
{
	testAppDelegate = [[AppDelegate alloc] init];
	someNotification = [[UILocalNotification alloc] init];
}

- (void)testAppDelegateSetsUpCoreDataStack
{
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

- (void)testOnAppDelegate_WhenReceivingLocalNotification_ItFindsTheTimerProfileAndHandlesIt
{
	NSManagedObjectContext* testContext = [self managedObjectTestContext];
	TimerProfile* someProfile = [TimerProfile createWithName:@"Some Timer" duration:10 managedObjectContext:testContext];
	[testAppDelegate setManagedObjectContext:testContext];
	
	NSError* saveError;
	BOOL saveSuccess = [testContext save:&saveError];
	XCTAssertTrue(saveSuccess, @"Saving failed with error: %@", saveError);
	
	[someNotification setUserInfo:@{ @"timerProfileURI" : [someProfile.managedObjectIDAsURI absoluteString]}];
	AppDelegate* partialAppDelegate = OCMPartialMock(testAppDelegate);
	
	
	[testAppDelegate application:[UIApplication sharedApplication] didReceiveLocalNotification:someNotification];
	
	OCMVerify([partialAppDelegate handleExpiredTimer:someProfile]);
}

- (void)testOnAppDelegate_WhenReceivingLocalNotification_ItPostsAnAlertForTheNotification
{
	XCTAssertNotNil([testAppDelegate timerAlert]);
	
	UIAlertView* mockAlert = OCMClassMock([UIAlertView class]);
	[testAppDelegate setTimerAlert:mockAlert];
	
	NSManagedObjectContext* testContext = [self managedObjectTestContext];
	TimerProfile* someProfile = [TimerProfile createWithName:@"Some Timer" duration:10 managedObjectContext:testContext];
	[testAppDelegate setManagedObjectContext:testContext];
	
	NSError* saveError;
	BOOL saveSuccess = [testContext save:&saveError];
	XCTAssertTrue(saveSuccess, @"Saving failed with error: %@", saveError);
	
	[someNotification setUserInfo:@{ @"timerProfileURI" : [someProfile.managedObjectIDAsURI absoluteString]}];
	
	[testAppDelegate application:[UIApplication sharedApplication] didReceiveLocalNotification:someNotification];
	
	OCMVerify([mockAlert setTitle:@"Some Timer"]);
	OCMVerify([mockAlert show]);
}

- (void)testOnAppDelegate_WhenTheAlertIsDismissed_ItResetsTheCountdown
{
    XCTAssertTrue([testAppDelegate conformsToProtocol:@protocol(UIAlertViewDelegate)]);
}

- (void)testOnAppDelegate_WhenAppBecomesActive_ItStopsAllExpiredTimers
{
	TimerProfile* mockExpiredProfile = OCMClassMock([TimerProfile class]);
    TimerProfileStore* stubStore = OCMClassMock([TimerProfileStore class]);
	OCMStub([stubStore fetchExpiredTimerProfiles]).andReturn(@[mockExpiredProfile]);
	[testAppDelegate setTimerProfileStore:stubStore];

	[testAppDelegate applicationDidBecomeActive:nil];
	
	OCMVerify([mockExpiredProfile stopCountdown]);
}

- (void)testOnAppDelegate_WhenAppBecomesActive_ItUpdatesAllRunningTimers
{
    TimerProfile* runningTimer = [[testAppDelegate timerProfileStore] createTimerProfileWithName:@"Running" duration:10];
	[runningTimer startCountdown];
	[runningTimer setRemainingTime:20];

	TimerProfile* notRunningTimer = [[testAppDelegate timerProfileStore] createTimerProfileWithName:@"Not running" duration:30];
	[notRunningTimer startCountdown];
	[notRunningTimer pauseCountdown];
	
	[testAppDelegate applicationDidBecomeActive:nil];
	
	XCTAssertEqualWithAccuracy([runningTimer remainingTime], 10, 0.01);
	XCTAssertEqual([notRunningTimer remainingTime], 30);
}

@end

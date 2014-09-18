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
#import "TimerProfile.h"

@interface AppDelegateTests : XCTestCase {
	UILocalNotification* someNotification;
	AppDelegate* appDelegate;
}

@end

@implementation AppDelegateTests

- (void)setUp
{
	appDelegate = [[AppDelegate alloc] init];
	someNotification = [[UILocalNotification alloc] init];
}

- (void)testAppDelegateSetsUpCoreDataStack
{
	NSManagedObjectContext* appContext = [appDelegate managedObjectContext];
	
	XCTAssertNotNil(appContext);
	XCTAssertEqual([appContext concurrencyType], NSMainQueueConcurrencyType);
	XCTAssertNotNil([appContext persistentStoreCoordinator]);
	XCTAssertNotEqual([appContext.persistentStoreCoordinator.persistentStores count], 0);
}

- (void)testOnAppDelegate_WhenReceivingLocalNotification_ItFindsTheTimerProfileAndPausesTheCountdown
{
	NSManagedObjectContext* testContext = [self managedObjectTestContext];
	TimerProfile* someProfile = [TimerProfile createWithName:@"Some Timer" duration:10 managedObjectContext:testContext];
	[appDelegate setManagedObjectContext:testContext];
	
	NSError* saveError;
	BOOL saveSuccess = [testContext save:&saveError];
	XCTAssertTrue(saveSuccess, @"Saving failed with error: %@", saveError);
	
	[someNotification setUserInfo:@{ @"timerProfileURI" : [someProfile.managedObjectIDAsURI absoluteString]}];
	TimerProfile* partialTimer = OCMPartialMock(someProfile);
	
	[appDelegate application:[UIApplication sharedApplication] didReceiveLocalNotification:someNotification];
	
	OCMVerify([partialTimer pauseCountdown]);
}

- (void)testOnAppDelegate_WhenReceivingLocalNotification_ItPostsAnAlertForTheNotification
{
	XCTAssertNotNil([appDelegate timerAlert]);
}

@end

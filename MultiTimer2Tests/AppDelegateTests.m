//
//  AppDelegateTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 01/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AppDelegate.h"

#import "TimerOverviewViewController.h"
#import "TimerProfileStore.h"

@interface AppDelegateTests : XCTestCase {
	AppDelegate* appDelegate;
}

@end

@implementation AppDelegateTests

- (void)setUp
{
	appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)testAppDelegateSetsUpCoreDataStack
{
	NSManagedObjectContext* appContext = [appDelegate managedObjectContext];
	
	XCTAssertNotNil(appContext);
	XCTAssertEqual([appContext concurrencyType], NSMainQueueConcurrencyType);
	XCTAssertNotNil([appContext persistentStoreCoordinator]);
	XCTAssertNotEqual([appContext.persistentStoreCoordinator.persistentStores count], 0);
}

- (void)testAppDelegateSetsTimerProfileStoreOnOverviewViewControllerWithManagedObjectContext
{
    TimerOverviewViewController* overviewViewController = (TimerOverviewViewController *)[(UINavigationController *)appDelegate.window.rootViewController topViewController];
	
	TimerProfileStore* store = [overviewViewController timerProfileStore];
	XCTAssertEqualObjects([store managedObjectContext] , [appDelegate managedObjectContext]);
}

- (void)testOnAppDelegate_ItCanReceiveLocalNotifications
{
	UILocalNotification* someNotification = [[UILocalNotification alloc] init];
    XCTAssertNoThrow([appDelegate application:[UIApplication sharedApplication] didReceiveLocalNotification: someNotification]);
}

@end

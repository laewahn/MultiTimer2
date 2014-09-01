//
//  AppDelegateTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 01/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AppDelegate.h"

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

@end

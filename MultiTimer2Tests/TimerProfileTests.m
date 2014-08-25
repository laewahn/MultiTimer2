//
//  TimerProfileTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TimerProfile.h"

@interface TimerProfileTests : XCTestCase {
	NSManagedObjectContext* someManagedObjectContext;
}

@end

@implementation TimerProfileTests

- (void)setUp
{
	[self setUpManagedObjectContext];
}

- (void)setUpManagedObjectContext
{
	someManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	
	NSBundle* resourceBundle = [NSBundle bundleForClass:[TimerProfile class]];
	NSURL* modelURL = [resourceBundle URLForResource:@"MultiTimer2" withExtension:@"momd"];
	
	NSManagedObjectModel* model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	NSPersistentStoreCoordinator* storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	
	[someManagedObjectContext setPersistentStoreCoordinator:storeCoordinator];
}

- (void)testTimerProfileCanBeCreatedWithManagedObjectContext
{
    TimerProfile* testProfile = [TimerProfile createWithManagedObjectContext:someManagedObjectContext];
	
	XCTAssertNotNil(testProfile);
	XCTAssertEqualObjects([testProfile managedObjectContext], someManagedObjectContext, @"Should know the managed object context.");
}


- (void)testTimerProfileCanBeCreatedWithNameDurationAndManagedObjectContext
{
	NSString* profileName = @"Test";
	NSTimeInterval profileDuration = 10;
	
	TimerProfile* testProfile = [TimerProfile createWithName:profileName duration:profileDuration managedObjectContext:someManagedObjectContext];

	XCTAssertNotNil(testProfile);
	XCTAssertEqualObjects([testProfile managedObjectContext], someManagedObjectContext, @"Should know the managed object context.");
	XCTAssertEqualObjects([testProfile name], profileName, @"Name should be set.");
	XCTAssertEqual([testProfile duration], profileDuration, @"Duration should be set.");
}

@end

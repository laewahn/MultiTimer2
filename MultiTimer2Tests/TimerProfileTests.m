//
//  TimerProfileTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTest+CoreDataTestStack.h"

#import "TimerProfile.h"

@interface TimerProfileTests : XCTestCase {
	NSManagedObjectContext* someManagedObjectContext;
}

@end

@implementation TimerProfileTests

- (void)setUp
{
	someManagedObjectContext = [self managedObjectTestContext];
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

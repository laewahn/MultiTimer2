//
//  TimerProfileStoreTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 26/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTest+CoreDataTestStack.h"

#import "TimerProfileStore.h"

@interface TimerProfileStoreTests : XCTestCase

@end


@implementation TimerProfileStoreTests

- (void)testStoreCanHaveManagedObjectContext
{
	NSManagedObjectContext* someContext = [self managedObjectTestContext];
	
    TimerProfileStore* testStore = [[TimerProfileStore alloc] init];
	[testStore setManagedObjectContext:someContext];
	
	XCTAssertEqualObjects([testStore managedObjectContext], someContext);
}

- (void)testStoreCanCreateTimerProfiles
{
    
}

- (void)testStoreFetchesAllTimerProfiles
{
    
}

- (void)testStoreHasFetchedResultsController
{
    
}

- (void)testFetchedResultsControllerIsInitializedLazily
{
    
}

@end

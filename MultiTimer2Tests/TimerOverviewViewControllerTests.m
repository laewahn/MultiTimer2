//
//  TimerOverviewViewControllerTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 26/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTest+CoreDataTestStack.h"

#import "TimerOverviewViewController.h"
#import "FetchedResultsDataSource.h"
#import "TimerProfileStore.h"

@interface TimerOverviewViewControllerTests : XCTestCase

@end

@implementation TimerOverviewViewControllerTests

- (void)testOverviewViewControllerHasFetchedResultsDataSourceAfterLoading
{
	NSBundle* mainBundle = [NSBundle bundleForClass:[TimerOverviewViewController class]];
	UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:mainBundle];
	
    TimerOverviewViewController* testVC = [storyBoard instantiateViewControllerWithIdentifier:@"TimerOverviewViewController"];
	
	XCTAssertNotNil([testVC.tableView dataSource]);
	XCTAssertTrue([[testVC.tableView dataSource] isKindOfClass:[FetchedResultsDataSource class]]);
}

- (void)testSettingTimerProfileStoreOnOverviewViewControllerConnectsTimerProfileFetchedResultsControllerWithDataSource
{
    NSBundle* mainBundle = [NSBundle bundleForClass:[TimerOverviewViewController class]];
	UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:mainBundle];
	
    TimerOverviewViewController* testVC = [storyBoard instantiateViewControllerWithIdentifier:@"TimerOverviewViewController"];
	
	TimerProfileStore* testStore = [[TimerProfileStore alloc] init];
	[testStore setManagedObjectContext:[self managedObjectTestContext]];
	
	[testVC setTimerProfileStore:testStore];
	
	XCTAssertEqualObjects([(FetchedResultsDataSource *)testVC.tableView.dataSource fetchedResultsController], [testStore timerProfilesFetchedResultsController]);
}

@end

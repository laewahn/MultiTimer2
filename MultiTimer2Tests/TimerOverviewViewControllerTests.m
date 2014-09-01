//
//  TimerOverviewViewControllerTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 26/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "XCTest+CoreDataTestStack.h"

#import "TimerOverviewViewController.h"
#import "FetchedResultsDataSource.h"
#import "TimerProfileStore.h"

@interface TimerOverviewViewControllerTests : XCTestCase {
	TimerOverviewViewController* testVC;
}
@end

@implementation TimerOverviewViewControllerTests

- (void)setUp
{
	NSBundle* mainBundle = [NSBundle bundleForClass:[TimerOverviewViewController class]];
	UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:mainBundle];
	
    testVC = [storyBoard instantiateViewControllerWithIdentifier:@"TimerOverviewViewController"];
}

- (void)testOverviewViewControllerHasFetchedResultsDataSourceAfterLoading
{
	XCTAssertNotNil([testVC.tableView dataSource]);
	XCTAssertTrue([[testVC.tableView dataSource] isKindOfClass:[FetchedResultsDataSource class]]);
}

- (void)testSettingTimerProfileStoreOnOverviewViewControllerConnectsTimerProfileFetchedResultsControllerWithDataSource
{
	TimerProfileStore* testStore = [[TimerProfileStore alloc] init];
	[testStore setManagedObjectContext:[self managedObjectTestContext]];
	
	[testVC setTimerProfileStore:testStore];
	
	XCTAssertEqualObjects([(FetchedResultsDataSource *)testVC.tableView.dataSource fetchedResultsController], [testStore timerProfilesFetchedResultsController]);
}

- (void)testOverviewViewControllerReloadsTableWhenStoreIsSet
{
    id mockTableView = OCMClassMock([UITableView class]);
	
	[testVC setTableView:mockTableView];
	[testVC setTimerProfileStore:nil];
	
	OCMVerify([mockTableView reloadData]);
}

@end

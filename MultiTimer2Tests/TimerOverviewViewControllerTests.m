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
#import "TimerProfile.h"
#import "CreateProfileViewController.h"
#import "TimerProfileTableViewCell.h"

@interface TimerOverviewViewControllerTests : XCTestCase {
	TimerOverviewViewController* testVC;
	TimerProfileStore* testStore;
	
	TimerProfile* someProfile;
}
@end

@implementation TimerOverviewViewControllerTests

- (void)setUp
{
	NSBundle* mainBundle = [NSBundle bundleForClass:[TimerOverviewViewController class]];
	UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:mainBundle];
	
    testVC = [storyBoard instantiateViewControllerWithIdentifier:@"TimerOverviewViewController"];
	
	testStore = [[TimerProfileStore alloc] init];
	[testStore setManagedObjectContext:[self managedObjectTestContext]];
	[testVC setTimerProfileStore:testStore];
	
	someProfile = [testStore createTimerProfileWithName:@"Some Profile" duration:10];
}

- (void)testTableViewHasFetchedResultsDataSourceAfterLoading
{
	XCTAssertNotNil([testVC.tableView dataSource]);
	XCTAssertTrue([[testVC.tableView dataSource] isKindOfClass:[FetchedResultsDataSource class]]);
}

- (void)testOverviewViewControllerSetsItselfAsDelegateForFetchedResultsController
{
	XCTAssertEqualObjects([(FetchedResultsDataSource *)testVC.tableView.dataSource delegate], testVC);
}

- (void)testOverviewViewControllerSetsTimerProfileFetchedResultsControllerOnDataSource
{
	XCTAssertEqualObjects([(FetchedResultsDataSource *)testVC.tableView.dataSource fetchedResultsController], [testStore timerProfilesFetchedResultsController]);
}

- (void)testOverviewViewControllerSetsTableOnDataSource
{
    XCTAssertEqualObjects([(FetchedResultsDataSource *)testVC.tableView.dataSource tableView], [testVC tableView]);
}

- (void)testOverviewViewControllerReloadsTableWhenStoreIsSet
{
    id mockTableView = OCMClassMock([UITableView class]);
	
	[testVC setTableView:mockTableView];
	[testVC setTimerProfileStore:nil];
	
	OCMVerify([mockTableView reloadData]);
}

- (void)testOnOverviewViewControllerTableView_ItCreatesTimerProfileTableViewCells
{
    UITableViewCell* someCell = [testVC.tableView dequeueReusableCellWithIdentifier:@"Cell"];
	XCTAssertTrue([someCell isKindOfClass:[TimerProfileTableViewCell class]]);
}

- (void)testOnOverviewController_WhenAskedToDeleteStoppedTimer_ItReturnsYES
{
	[someProfile stopTimer];
	
	XCTAssertTrue([testVC canDeleteObject:someProfile]);
}

- (void)testOnOverviewViewController_WhenAskedToDeleteRunningTimer_ItReturnsNO
{
	[someProfile startTimer];
	
	XCTAssertFalse([testVC canDeleteObject:someProfile]);
	
	[someProfile stopTimer];
}

- (void)testOverviewViewControllerConfiguresCells
{
	TimerProfileTableViewCell* someCell = [testVC.tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	NSString* profileName = @"The final countdown.";
	someProfile = [testStore createTimerProfileWithName:profileName duration:10];
	
	[testVC configureCell:someCell withObject:someProfile];
	
	XCTAssertEqualObjects([someCell.nameLabel text], profileName);
	XCTAssertEqualObjects([someCell.durationLabel text], @"00:10");
}

- (void)testOverviewViewControllerHasAddButton
{
    UIBarButtonItem* addButton = [testVC addButton];
	XCTAssertNotNil(addButton);
}

@end

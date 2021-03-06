//
//  MultiTimer2IntegrationTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 26/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIBarButtonItem+UserInputSimulation.h"
#import "UIView+FindingViews.h"

#import "AppDelegate.h"
#import "TimerProfileStore.h"
#import "TimerOverviewViewController.h"
#import "FetchedResultsDataSource.h"
#import "CreateProfileViewController.h"
#import "DetailViewController.h"

@interface MultiTimer2IntegrationTests : XCTestCase {
	AppDelegate* appDelegate;
	TimerOverviewViewController* overviewViewController;
}
@end

@implementation MultiTimer2IntegrationTests

# pragma mark -
# pragma mark SetUp & TearDown

- (void)setUp
{
	appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	overviewViewController = (TimerOverviewViewController *)[(UINavigationController *)appDelegate.window.rootViewController topViewController];
	
	[self replaceTheSQLiteStoreWithTheFixtureStore];
}

- (void)tearDown
{
	[overviewViewController dismissViewControllerAnimated:YES completion:nil];
	[overviewViewController.navigationController popToRootViewControllerAnimated:NO];
}

- (void)replaceTheSQLiteStoreWithTheFixtureStore
{
	[appDelegate.managedObjectContext reset];
	
	NSBundle* testBundle = [NSBundle bundleForClass:[self class]];
	NSURL* urlForFixtureDatabase = [testBundle URLForResource:@"MultiTimer2Fixtures" withExtension:@"sqlite"];
	
	NSURL* fixturesCopyURL = [urlForFixtureDatabase URLByAppendingPathExtension:@"Copy"];
	[[NSFileManager defaultManager] removeItemAtURL:fixturesCopyURL error:nil];
	
	NSError* copyError;
	BOOL copySuccess = [[NSFileManager defaultManager] copyItemAtURL:urlForFixtureDatabase toURL:fixturesCopyURL error:&copyError];
	NSAssert(copySuccess, @"Copying fixtures failed with error: %@", copyError);
	
	NSPersistentStoreCoordinator* storeCoordinator = [appDelegate.managedObjectContext persistentStoreCoordinator];
	for (NSPersistentStore* store in [storeCoordinator persistentStores]) {
		NSError* removeStoreError;
		[storeCoordinator removePersistentStore:store error:&removeStoreError];
		
		NSAssert(removeStoreError == nil, @"Removing store: %@ failed with error: %@", store, removeStoreError);
	}
		
	NSError* addStoreError;
	NSPersistentStore* fixtureStore = [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
																	 configuration:nil
																			   URL:fixturesCopyURL
																		   options:nil
																			 error:&addStoreError];
	NSAssert(addStoreError == nil, @"Adding store: %@ failed with error: %@", fixtureStore, addStoreError);
	
	[((FetchedResultsDataSource *)overviewViewController.tableView.dataSource).fetchedResultsController performFetch:nil];
	[overviewViewController.tableView reloadData];
}


# pragma mark -
# pragma mark Application Setup Tests

- (void)testAppStarts
{
    UIApplication* app = [UIApplication sharedApplication];
	XCTAssertNotNil(app);
}

- (void)testAppDelegateSetsTimerProfileStoreOnOverviewViewControllerWithManagedObjectContext
{
	TimerProfileStore* store = [overviewViewController timerProfileStore];
	XCTAssertEqualObjects([store managedObjectContext] , [appDelegate managedObjectContext]);
}


# pragma mark -
# pragma mark User Interaction Tests

- (void)testWhenTheAppStartsTheUserIsPresentedAListOfTimers
{
	NSArray* cells = [overviewViewController.tableView visibleCells];
	XCTAssertNotEqual([cells count], 0);

	NSIndexPath* firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
	UITableViewCell* firstCell = [overviewViewController.tableView cellForRowAtIndexPath:firstCellIndexPath];
	
	XCTAssertNotNil([firstCell.contentView findLabelWithText:@"Black Tea"]);
	XCTAssertNotNil([firstCell.contentView findLabelWithText:@"03:00"]);
}

# pragma mark :: Create a new Profile ::

- (void)testWhenTheUserPressesTheAddButtonTheCreateTimerProfileViewIsPresented
{
    UIBarButtonItem* addButton = [overviewViewController addButton];
	[[addButton target] performSelectorOnMainThread:[addButton action] withObject:addButton waitUntilDone:YES];
	
	UIViewController* createProfileViewController = [overviewViewController presentedViewController];
	XCTAssertEqual([createProfileViewController class], [CreateProfileViewController class]);
}

- (void)testWhenTheUserEntersTimerProfileInformationInTheCreateProfileDialogAndPressesSaveTheNewProfileIsVisibleInTheTable
{
	[[overviewViewController addButton] simulateTap];
	
	CreateProfileViewController* createProfileViewController = (CreateProfileViewController *)[overviewViewController presentedViewController];
	XCTAssertNotNil([createProfileViewController timerProfileStore]);
	
	[[createProfileViewController.view findTextfieldWithPlaceHolderText:@"Profile Name"] setText:@"Green Tea"];
	[[createProfileViewController.view findCountdownPickerView] setCountDownDuration:3660];
	
	[[createProfileViewController doneButton] simulateTap];
	XCTAssertNil([overviewViewController presentedViewController]);
	
	NSArray* cells = [overviewViewController.tableView visibleCells];
	XCTAssertEqual([cells count], 2);
	
	NSIndexPath* firstCellIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
	UITableViewCell* firstCell = [overviewViewController.tableView cellForRowAtIndexPath:firstCellIndexPath];
	XCTAssertNotNil([firstCell.contentView findLabelWithText:@"Green Tea"]);
	XCTAssertNotNil([firstCell.contentView findLabelWithText:@"1:01:00"]);
}

- (void)testWhenTheUserCancelsCreatingNewTimerProfileNoNewProfileIsInTheTable
{
	NSArray* cellsBeforeCancel = [overviewViewController.tableView visibleCells];
	
    [[overviewViewController addButton] simulateTap];
	
	CreateProfileViewController* createProfileViewController = (CreateProfileViewController *)[overviewViewController presentedViewController];
	[[createProfileViewController cancelButton] simulateTap];
	
	XCTAssertNil([overviewViewController presentedViewController]);
	
	NSArray* cellsAfterCancel = [overviewViewController.tableView visibleCells];
	XCTAssertEqualObjects(cellsBeforeCancel, cellsAfterCancel);
}

# pragma mark :: Show Timer Details ::

- (void)testWhenTheUserSelectsATimerProfileTheDetailViewForTheTimerIsShown
{
	[overviewViewController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
	[overviewViewController performSegueWithIdentifier:@"showDetail" sender:[overviewViewController tableView]];
	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
	
	DetailViewController* detailViewController = (DetailViewController *)[overviewViewController.navigationController topViewController];
	XCTAssertEqual([detailViewController class], [DetailViewController class]);
	XCTAssertEqualObjects([detailViewController title], @"Black Tea");

	UILabel* durationLabel = (UILabel *)[detailViewController.view findViewWithClass:[UILabel class] additionalFilter:^BOOL(UILabel* label) {
		return [label.accessibilityLabel isEqualToString:@"Duration Label"];
	}];
	
	XCTAssertNotNil(durationLabel);
	XCTAssertEqualObjects([durationLabel text], @"03:00");
}

@end

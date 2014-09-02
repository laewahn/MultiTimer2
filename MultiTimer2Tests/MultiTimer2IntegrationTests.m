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
#import "TimerOverviewViewController.h"
#import "FetchedResultsDataSource.h"
#import "CreateProfileViewController.h"

@interface MultiTimer2IntegrationTests : XCTestCase {
	AppDelegate* appDelegate;
	TimerOverviewViewController* overviewViewController;
}
@end

@implementation MultiTimer2IntegrationTests

- (void)setUp
{
	appDelegate = [[UIApplication sharedApplication] delegate];
	overviewViewController = (TimerOverviewViewController *)[(UINavigationController *)appDelegate.window.rootViewController topViewController];
	
	[self replaceTheSQLiteStoreWithTheFixtureStore];
}

- (void)replaceTheSQLiteStoreWithTheFixtureStore
{
	[appDelegate.managedObjectContext reset];
	
	NSPersistentStoreCoordinator* storeCoordinator = [appDelegate.managedObjectContext persistentStoreCoordinator];
	for (NSPersistentStore* store in [storeCoordinator persistentStores]) {
		NSError* removeStoreError;
		[storeCoordinator removePersistentStore:store error:&removeStoreError];
		
		NSAssert(removeStoreError == nil, @"Removing store: %@ failed with error: %@", store, removeStoreError);
	}
	
	NSBundle* testBundle = [NSBundle bundleForClass:[self class]];
	NSURL* urlForFixtureDatabase = [testBundle URLForResource:@"MultiTimer2Fixtures" withExtension:@"sqlite"];
	
	NSError* addStoreError;
	NSPersistentStore* fixtureStore = [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
																	 configuration:nil
																			   URL:urlForFixtureDatabase
																		   options:nil
																			 error:&addStoreError];
	NSAssert(addStoreError == nil, @"Adding store: %@ failed with error: %@", fixtureStore, addStoreError);
	
	[((FetchedResultsDataSource *)overviewViewController.tableView.dataSource).fetchedResultsController performFetch:nil];
	[overviewViewController.tableView reloadData];
}

- (void)testAppStarts
{
    UIApplication* app = [UIApplication sharedApplication];
	XCTAssertNotNil(app);
}

- (void)testWhenTheAppStartsTheUserIsPresentedAListOfTimers
{
	NSArray* cells = [overviewViewController.tableView visibleCells];
	XCTAssertNotEqual([cells count], 0);

	NSIndexPath* firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
	UITableViewCell* firstCell = [overviewViewController.tableView cellForRowAtIndexPath:firstCellIndexPath];
	XCTAssertEqualObjects([firstCell.textLabel text], @"Black Tea");
	XCTAssertEqualObjects([firstCell.detailTextLabel text], @"03:00");
}

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
	XCTAssertEqualObjects([firstCell.textLabel text], @"Green Tea");
	XCTAssertEqualObjects([firstCell.detailTextLabel text], @"1:01:00");
}

@end

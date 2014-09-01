//
//  MultiTimer2IntegrationTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 26/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AppDelegate.h"
#import "TimerOverviewViewController.h"
#import "FetchedResultsDataSource.h"
#import "TimerProfileStore.h"

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
	
	[overviewViewController.timerProfileStore.timerProfilesFetchedResultsController performFetch:nil];
	[overviewViewController.tableView reloadData];
}

- (void)testAppStarts
{
    UIApplication* app = [UIApplication sharedApplication];
	XCTAssertNotNil(app);
}

- (void)testAppSetsUpCoreDataStack
{
	NSManagedObjectContext* appContext = [appDelegate managedObjectContext];
	
	XCTAssertNotNil(appContext);
	XCTAssertEqual([appContext concurrencyType], NSMainQueueConcurrencyType);
	XCTAssertNotNil([appContext persistentStoreCoordinator]);
	XCTAssertNotEqual([appContext.persistentStoreCoordinator.persistentStores count], 0);
}

- (void)testOverviewViewControllerTableViewIsInitializedWithFetchedResultsDataSource
{
	overviewViewController = (TimerOverviewViewController *)[(UINavigationController *)appDelegate.window.rootViewController topViewController];
	
	XCTAssertTrue([[overviewViewController.tableView dataSource] isKindOfClass:[FetchedResultsDataSource class]]);
}

- (void)testOverviewViewControllerTimerProfileStoreIsSetUpWithManagedObjectContext
{
    overviewViewController = (TimerOverviewViewController *)[(UINavigationController *)appDelegate.window.rootViewController topViewController];
	
	TimerProfileStore* store = [overviewViewController timerProfileStore];
	XCTAssertEqualObjects([store managedObjectContext] , [appDelegate managedObjectContext]);
}

- (void)testWhenTheAppStartsTheUserIsPresentedAListOfTimers
{
	NSIndexPath* firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
	UITableViewCell* firstCell = [overviewViewController.tableView cellForRowAtIndexPath:firstCellIndexPath];
	
	NSArray* cells = [overviewViewController.tableView visibleCells];
	XCTAssertNotNil(cells);
	
	XCTAssertNotEqual([cells count], 0);
}


@end

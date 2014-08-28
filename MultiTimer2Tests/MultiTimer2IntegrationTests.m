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
}
@end

@implementation MultiTimer2IntegrationTests

- (void)setUp
{
	appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)tearDown
{
	[self clearSQLiteStore];
}

- (void)clearSQLiteStore
{
	NSURL* sqliteFileURL = [[appDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"MultiTimer2.sqlite"];

	if ([[NSFileManager defaultManager] fileExistsAtPath:[sqliteFileURL path]]) {
		NSError* fileDeletionError;
		BOOL fileDeletionSuccess = [[NSFileManager defaultManager] removeItemAtURL:sqliteFileURL error:&fileDeletionError];
		
		NSAssert(fileDeletionSuccess, @"Clearing SQLite file failed with error: %@", fileDeletionError);
	}
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
	TimerOverviewViewController* overviewViewController = (TimerOverviewViewController *)[(UINavigationController *)appDelegate.window.rootViewController topViewController];
	
	XCTAssertTrue([[overviewViewController.tableView dataSource] isKindOfClass:[FetchedResultsDataSource class]]);
}

- (void)testOverviewViewControllerTimerProfileStoreIsSetUpWithManagedObjectContext
{
    TimerOverviewViewController* overviewViewController = (TimerOverviewViewController *)[(UINavigationController *)appDelegate.window.rootViewController topViewController];
	
	TimerProfileStore* store = [overviewViewController timerProfileStore];
	XCTAssertEqualObjects([store managedObjectContext] , [appDelegate managedObjectContext]);
}
@end

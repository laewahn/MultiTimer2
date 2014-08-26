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

@interface MultiTimer2IntegrationTests : XCTestCase

@end

@implementation MultiTimer2IntegrationTests

- (void)testAppStarts
{
    UIApplication* app = [UIApplication sharedApplication];
	XCTAssertNotNil(app);
}

- (void)testOverviewViewControllerTableViewIsInitializedWithFetchedResultsDataSource
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	TimerOverviewViewController* overviewViewController = (TimerOverviewViewController *)[(UINavigationController *)appDelegate.window.rootViewController topViewController];
	
	XCTAssertTrue([[overviewViewController.tableView dataSource] isKindOfClass:[FetchedResultsDataSource class]]);
}

- (void)testFetchedResultsDataSourceHasFetchedResultsController
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	TimerOverviewViewController* overviewViewController = (TimerOverviewViewController *)[(UINavigationController *)appDelegate.window.rootViewController topViewController];
	
	NSFetchedResultsController* frc = [(FetchedResultsDataSource *)overviewViewController.tableView.dataSource fetchedResultsController];
	XCTAssertNotNil(frc);
}
@end

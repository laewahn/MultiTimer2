//
//  FetchedResultsDataSourceTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "FetchedResultsDataSource.h"

@interface FetchedResultsDataSourceTests : XCTestCase {
	FetchedResultsDataSource* testDataSource;
	
	NSArray* stubSectionWithOneRow;
	NSString* testReuseIdentifier;
	NSIndexPath* pathForTestRow;
}

@end

@implementation FetchedResultsDataSourceTests

- (void)setUp
{
	testDataSource = [[FetchedResultsDataSource alloc] init];

	stubSectionWithOneRow = [NSArray arrayWithObject:@[@"one"]];
	testReuseIdentifier = @"TestCell";
	pathForTestRow = [NSIndexPath indexPathForItem:0 inSection:0];
	
	[testDataSource setFetchedResultsController:[self stubFetchedResultsControllerWithSectionsAndRows:stubSectionWithOneRow]];
}

- (NSFetchedResultsController *)stubFetchedResultsControllerWithSectionsAndRows:(NSArray *)sectionsAndRows
{
	id stubFRC = OCMClassMock([NSFetchedResultsController class]);
	OCMStub([stubFRC sections]).andReturn(stubSectionWithOneRow);
	
	return stubFRC;
}

- (void)testDataSourceCanHaveFetchedResultsController
{
	id stubFRC = [self stubFetchedResultsControllerWithSectionsAndRows:stubSectionWithOneRow];
	[testDataSource setFetchedResultsController:stubFRC];
	XCTAssertEqualObjects([testDataSource fetchedResultsController], stubFRC);
}

- (void)testDataSourceImplementsUITableViewDataSourceProtocol
{
    XCTAssertTrue([testDataSource conformsToProtocol:@protocol(UITableViewDataSource)]);
}

- (void)testDataSourceReturnsNumberOfSectionsOfFetchedResultsController
{
	XCTAssertEqual([testDataSource numberOfSectionsInTableView:nil], [stubSectionWithOneRow count]);
}

- (void)testDataSourceReturnsNumberOfRowsForSectionOfFetchedResultsController
{
	XCTAssertEqual([testDataSource tableView:nil numberOfRowsInSection:0], [[stubSectionWithOneRow objectAtIndex:0] count]);
}

- (void)testTableViewCellReuseIdentifierCanBeSepecifiedForDataSource
{
	[testDataSource setCellReuseIdentifier:testReuseIdentifier];
	XCTAssertEqualObjects([testDataSource cellReuseIdentifier], testReuseIdentifier);
}

- (void)testDataSourceReturnsDequeuedCellWithGivenIdentifierForRow
{
	[testDataSource setCellReuseIdentifier:testReuseIdentifier];
	UITableViewCell* expectedCell = [[UITableViewCell alloc] init];
	
    UITableView* stubTableView = [self stubTableViewDequeueingCell:expectedCell forReuseIdentifier:testReuseIdentifier];
	
	XCTAssertEqualObjects([testDataSource tableView:stubTableView cellForRowAtIndexPath:pathForTestRow], expectedCell);
}

- (void)testDataSourceUsesBlockToConfigureCellContent
{
	__block BOOL blockWasCalled = NO;
	
	NSString* expectedObject = [[stubSectionWithOneRow firstObject] firstObject];
	
    void(^testConfigurationBlock)(UITableViewCell* cell, id object) = ^(UITableViewCell* cell, id object) {
		blockWasCalled = YES;
		XCTAssertNotNil(cell);
		XCTAssertEqual(object, expectedObject);
		XCTAssertTrue([object isKindOfClass:[NSString class]]);
		
		[cell.textLabel setText:object];
	};
	
	[testDataSource setCellConfigurationBlock:testConfigurationBlock];
	
	UITableViewCell* someCell = [[UITableViewCell alloc] init];
	UITableView* stubTableView = [self stubTableViewDequeueingCell:someCell forReuseIdentifier:OCMOCK_ANY];
	OCMStub([testDataSource.fetchedResultsController objectAtIndexPath:pathForTestRow]).andReturn(expectedObject);
	
	[testDataSource tableView:stubTableView cellForRowAtIndexPath:pathForTestRow];
	
	XCTAssertTrue(blockWasCalled);
	XCTAssertEqualObjects([someCell.textLabel text], expectedObject);
}

- (UITableView *)stubTableViewDequeueingCell:(UITableViewCell *)someCell forReuseIdentifier:(NSString *)reuseIdentifier
{
	UITableView* tableViewStub = OCMClassMock([UITableView class]);
	OCMStub([tableViewStub dequeueReusableCellWithIdentifier:reuseIdentifier]).andReturn(someCell);
	
	return tableViewStub;
	
}

@end

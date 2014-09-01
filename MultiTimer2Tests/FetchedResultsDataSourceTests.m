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

#define OCMOCK_ANY_ERROR ((NSError __autoreleasing **)[OCMArg anyPointer])

static NSString* const kTestReuseIdentifier = @"TestCell";

@interface FetchedResultsDataSourceTests : XCTestCase {
	FetchedResultsDataSource* testDataSource;
	
	NSArray* sections;
	NSIndexPath* pathForTestRow;
	
	UITableViewCell* someCell;
	UITableView* stubTableView;
}

@end

@implementation FetchedResultsDataSourceTests

- (void)setUp
{
	testDataSource = [[FetchedResultsDataSource alloc] init];
	
	id<NSFetchedResultsSectionInfo> stubSectionWithOneRow = OCMProtocolMock(@protocol(NSFetchedResultsSectionInfo));
	OCMStub([stubSectionWithOneRow objects]).andReturn(@[@"one"]);
	sections = [NSArray arrayWithObject:stubSectionWithOneRow];

	pathForTestRow = [NSIndexPath indexPathForItem:0 inSection:0];

	someCell = [[UITableViewCell alloc] init];
	stubTableView = [self stubTableViewDequeueingCell:someCell forReuseIdentifier:OCMOCK_ANY];

	[testDataSource setFetchedResultsController:[self stubFetchedResultsControllerWithSectionsAndRows:sections]];
}

- (NSFetchedResultsController *)stubFetchedResultsControllerWithSectionsAndRows:(NSArray *)sectionsAndRows
{
	id stubFRC = OCMClassMock([NSFetchedResultsController class]);
	OCMStub([stubFRC sections]).andReturn(sections);
	
	return stubFRC;
}

- (void)testDataSourceCanHaveFetchedResultsController
{
	id stubFRC = [self stubFetchedResultsControllerWithSectionsAndRows:sections];
	[testDataSource setFetchedResultsController:stubFRC];
	XCTAssertEqualObjects([testDataSource fetchedResultsController], stubFRC);
}

- (void)testDataSourcePerformsFetchWhenFetchedResultsControllerIsSet
{
    id stubFRC = OCMClassMock([NSFetchedResultsController class]);
	
	[testDataSource setFetchedResultsController:stubFRC];
	
	OCMVerify([stubFRC performFetch:OCMOCK_ANY_ERROR]);
}

- (void)testDataSourceImplementsUITableViewDataSourceProtocol
{
    XCTAssertTrue([testDataSource conformsToProtocol:@protocol(UITableViewDataSource)]);
}

- (void)testDataSourceReturnsNumberOfSectionsOfFetchedResultsController
{
	XCTAssertEqual([testDataSource numberOfSectionsInTableView:nil], [sections count]);
}

- (void)testDataSourceReturnsNumberOfRowsForSectionOfFetchedResultsController
{
	XCTAssertEqual([testDataSource tableView:nil numberOfRowsInSection:0], [[sections objectAtIndex:0] numberOfObjects]);
}

- (void)testTableViewCellReuseIdentifierCanBeSepecifiedForDataSource
{
	[testDataSource setCellReuseIdentifier:kTestReuseIdentifier];
	XCTAssertEqualObjects([testDataSource cellReuseIdentifier], kTestReuseIdentifier);
}

- (void)testDataSourceReturnsDequeuedCellWithGivenIdentifierForRow
{
	[testDataSource setCellReuseIdentifier:kTestReuseIdentifier];
	
	XCTAssertEqualObjects([testDataSource tableView:stubTableView cellForRowAtIndexPath:pathForTestRow], someCell);
}

- (void)testDataSourceHasDelegate
{
    id<FetchedResultsDataSourceDelegate> delegateMock = OCMProtocolMock(@protocol(FetchedResultsDataSourceDelegate));
	[testDataSource setDelegate:delegateMock];
	
	XCTAssertEqualObjects([testDataSource delegate], delegateMock);
}

- (void)testDataSourceCallsDelegateForCellConfiguration
{
	NSArray* objectsInSection = [[sections firstObject] objects];
	NSString* expectedObject = [objectsInSection firstObject];
	
	OCMStub([testDataSource.fetchedResultsController objectAtIndexPath:pathForTestRow]).andReturn(expectedObject);
		
	id<FetchedResultsDataSourceDelegate> delegateMock = OCMProtocolMock(@protocol(FetchedResultsDataSourceDelegate));
	[testDataSource setDelegate:delegateMock];
	
	[testDataSource tableView:stubTableView cellForRowAtIndexPath:pathForTestRow];
	
	OCMVerify([delegateMock configureCell:someCell withObject:expectedObject]);
}

- (UITableView *)stubTableViewDequeueingCell:(UITableViewCell *)aCell forReuseIdentifier:(NSString *)reuseIdentifier
{
	UITableView* tableViewStub = OCMClassMock([UITableView class]);
	OCMStub([tableViewStub dequeueReusableCellWithIdentifier:reuseIdentifier]).andReturn(aCell);
	
	return tableViewStub;	
}

@end

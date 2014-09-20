//
//  TimerProfileTableViewCellTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 15/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "TimerProfileTableViewCell.h"
#import "TimerProfileViewModel.h"

#import "XCTest+CoreDataTestStack.h"
#import "TimerProfile.h"

@interface TimerProfileTableViewCellTests : XCTestCase {
	TimerProfileTableViewCell* testCell;
	TimerProfileViewModel* mockViewModel;
	TimerProfileViewModel* realViewModel;
	
	NSManagedObjectContext* context;
	TimerProfile* someProfile;
}
@end

@implementation TimerProfileTableViewCellTests

- (void)setUp
{
	NSBundle* mainBundle = [NSBundle bundleForClass:[TimerProfileTableViewCell class]];
	NSArray* nibContents =[mainBundle loadNibNamed:@"TimerProfileTableViewCell" owner:testCell options:nil];
	
	testCell = [nibContents firstObject];
	
	mockViewModel = OCMClassMock([TimerProfileViewModel class]);
	
	context = [self managedObjectTestContext];
	someProfile = [TimerProfile createWithName:@"Some Profile" duration:10 managedObjectContext:context];
	realViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:someProfile];
}

- (void)testOnTimerProfileTableViewCell_ItCanHaveATimerProfileViewModel
{
	[testCell setViewModel:realViewModel];
	XCTAssertEqualObjects([testCell viewModel], realViewModel);
}

- (void)testOnTimerProfileTableViewCell_WhenSettingTheViewModel_ItRegistersAsObserver
{
	[[[(id)mockViewModel expect] ignoringNonObjectArgs] addObserver:testCell forKeyPath:@"duration" options:0 context:[OCMArg anyPointer]];
	[[[(id)mockViewModel expect] ignoringNonObjectArgs] addObserver:testCell forKeyPath:@"name" options:0 context:[OCMArg anyPointer]];
	
	[testCell setViewModel:mockViewModel];
	
	[(id)mockViewModel verify];
}

- (void)testOnTimerProfileTableViewCellWithViewModel_WhenSettingANewViewModel_ItRemovesAsObserverFromTheOldViewModel
{
	[testCell setViewModel:mockViewModel];

	[[(id)mockViewModel expect] removeObserver:testCell forKeyPath:@"duration"];
	[[(id)mockViewModel expect] removeObserver:testCell forKeyPath:@"name"];

	[testCell setViewModel:nil];
	
	[(id)mockViewModel verify];
}

- (void)testOnTimerProfileTableViewCell_ItHandlesKVOUpdates
{
	NSDictionary* someChange = @{
								 NSKeyValueChangeNewKey : @3
								 };
	
    XCTAssertNoThrow([testCell observeValueForKeyPath:@"duration" ofObject:mockViewModel change:someChange context:TimerProfileRemainingTimeContext]);
}

- (void)testOnTimerProfileTableViewCell_WhenTheDurationIsInitialized_ItUpdatesTheDurationLabel
{
	[testCell setViewModel:realViewModel];
	
	XCTAssertEqualObjects([testCell.durationLabel text], @"00:10");
}

- (void)testOnTimerProfileTableViewCell_WhenTheDurationUpdates_ItUpdatesTheDurationLabel
{
	[testCell setViewModel:realViewModel];

	XCTAssertEqualObjects([testCell.durationLabel text], @"00:10");
	
	[someProfile setRemainingTime:5];
	XCTAssertEqualObjects([testCell.durationLabel text], @"00:05");
}

- (void)testOnTimerProfileTableViewCell_WhenTheViewModelIsSet_TheNameLabelIsSet
{
	[testCell setViewModel:realViewModel];
	
	XCTAssertEqualObjects([testCell.nameLabel text], @"Some Profile");
}

@end

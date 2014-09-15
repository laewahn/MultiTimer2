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

@interface TimerProfileTableViewCellTests : XCTestCase {
	TimerProfileTableViewCell* testCell;
	TimerProfileViewModel* mockViewModel;
}
@end

@implementation TimerProfileTableViewCellTests

- (void)setUp
{
	testCell = [[TimerProfileTableViewCell alloc] init];
	mockViewModel = OCMClassMock([TimerProfileViewModel class]);
}

- (void)testOnTimerProfileTableViewCell_ItCanHaveATimerProfileViewModel
{
	TimerProfileViewModel* someViewModel= [[TimerProfileViewModel alloc] init];
	
	[testCell setViewModel:someViewModel];
	XCTAssertEqualObjects([testCell viewModel], someViewModel);
}

- (void)testOnTimerProfileTableViewCell_WhenSettingTheViewModel_ItRegistersAsObserver
{
	[[[(id)mockViewModel expect] ignoringNonObjectArgs] addObserver:testCell forKeyPath:@"duration" options:0 context:[OCMArg anyPointer]];
	
	[testCell setViewModel:mockViewModel];
	
	[(id)mockViewModel verify];
}

- (void)testOnTimerProfileTableViewCellWithViewModel_WhenSettingANewViewModel_ItRemovesAsObserverFromTheOldViewModel
{
	[[(id)mockViewModel expect] removeObserver:testCell forKeyPath:@"duration"];
	[testCell setViewModel:mockViewModel];
	
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

- (void)testOnTimerProfileTableViewCell_WhenTheDurationUpdates_ItUpdatesTheDurationLabel
{
    XCTFail(@"NYI");
}

- (void)testOnTimerProfileTableViewCell_WhenTheDurationIsInitialized_ItUpdatesTheDurationLabel
{
    XCTFail(@"NYI");
}

- (void)testOnTimerProfileTableViewCell_WhenTheViewModelIsSet_TheNameLabelIsSet
{
    XCTFail(@"NYI");
}

@end

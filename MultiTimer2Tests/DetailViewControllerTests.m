//
//  DetailViewControllerTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 03/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "UIView+FindingViews.h"

#import "DetailViewController.h"
#import "TimerProfileViewModel.h"

@interface DetailViewControllerTests : XCTestCase {
	DetailViewController* testVC;
	TimerProfileViewModel* mockViewModel;
}
@end

@implementation DetailViewControllerTests

- (void)setUp
{
	NSBundle* mainBundle = [NSBundle bundleForClass:[DetailViewController class]];
	UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:mainBundle];
	
	testVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
	[testVC view];
	
	mockViewModel = OCMClassMock([TimerProfileViewModel class]);
}

- (void)testDetailViewControllerHasStartButton
{
	UIButton* startButton = (UIButton *)[testVC.view findViewWithClass:[UIButton class] additionalFilter:^BOOL(UIButton *button) {
		return [button.titleLabel.text isEqualToString:@"Start"];
	}];
	
	XCTAssertNotNil(startButton);
}

- (void)testOnDetailViewController_ItCanHaveTimerProfileViewModel
{
	[testVC setTimerProfileViewModel:mockViewModel];
	XCTAssertEqualObjects([testVC timerProfileViewModel], mockViewModel);
}

- (void)testOnDetailViewController_WhenSettingTheTimerProfileViewModel_ItAddsItselfAsObserver
{
	[[[(id)mockViewModel expect] ignoringNonObjectArgs] addObserver:OCMOCK_ANY forKeyPath:@"duration" options:0 context:[OCMArg anyPointer]];
	
	[testVC setTimerProfileViewModel:mockViewModel];

	[(id)mockViewModel verify];
}

- (void)testOnDetailViewControllerWithTimerProfileViewModel_WhenANewViewModelIsSet_ItRemovesItselfAsObserverFromTheOldViewModel
{
    [testVC setTimerProfileViewModel:mockViewModel];
	[[(id)mockViewModel expect] removeObserver:testVC forKeyPath:@"duration"];
	
	[testVC setTimerProfileViewModel:nil];
	
	[(id)mockViewModel verify];
}

- (void)testOnDetailViewController_ItCanHandleViewModelUpdates
{
	NSDictionary* someChanges = @{
								  NSKeyValueChangeNewKey : @3
								  };
	
    XCTAssertNoThrow([testVC observeValueForKeyPath:@"duration" ofObject:mockViewModel change:someChanges context:TimerProfileRemainingTimeContext]);
}

@end

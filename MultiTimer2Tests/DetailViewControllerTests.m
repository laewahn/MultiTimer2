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
	
	TimerProfileViewModel* someViewModel;
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
	
	someViewModel = [[TimerProfileViewModel alloc] init];
	[testVC setTimerProfileViewModel:someViewModel];
	
}

- (void)testDetailViewControllerHasStartButton
{
	UIButton* startButton = [testVC.view findButtonWithTitle:@"Start"];
	
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
	
	[[[(id)mockViewModel expect] ignoringNonObjectArgs] addObserver:OCMOCK_ANY forKeyPath:@"countdownState" options:0 context:[OCMArg anyPointer]];
	
	[testVC setTimerProfileViewModel:mockViewModel];

	[(id)mockViewModel verify];
}

- (void)testOnDetailViewControllerWithTimerProfileViewModel_WhenANewViewModelIsSet_ItRemovesItselfAsObserverFromTheOldViewModel
{
    [testVC setTimerProfileViewModel:mockViewModel];
	[[(id)mockViewModel expect] removeObserver:testVC forKeyPath:@"duration"];
	[[(id)mockViewModel expect] removeObserver:testVC forKeyPath:@"countdownState"];
	
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

- (void)testOnDetailViewControllerWithTimerProfileViewModel_WhenStartButtonIsPressed_ItStartsTheCountdown
{
	[testVC setTimerProfileViewModel:mockViewModel];
    UIButton* startButton = [testVC.view findButtonWithTitle:@"Start"];
	
	[startButton sendActionsForControlEvents:UIControlEventTouchUpInside];
	
	OCMVerify([mockViewModel startCountdown]);
}

- (void)testOnDetailViewControllerWithTimerProfileStopped_ItShowsTheStartButtonAndDisablesTheStopButton
{
	[someViewModel setCountdownState:TimerProfileViewModelStateStopped];
	
	UIButton* startPauseButton = [testVC.view findButtonWithTitle:@"Start"];
	XCTAssertNotNil(startPauseButton);
	
	UIButton* stopResetButton = [testVC.view findButtonWithTitle:@"Stop"];
	XCTAssertNotNil(stopResetButton);
	XCTAssertFalse([stopResetButton isEnabled]);
}

- (void)testOnDetailViewControllerWithTimerProfileRunning_ItShowsThePauseButtonAndEnablesTheStopButton
{
	[someViewModel setCountdownState:TimerProfileViewModelStateRunning];
	
	UIButton* startPauseButton = [testVC.view findButtonWithTitle:@"Pause"];
	XCTAssertNotNil(startPauseButton);
	
	UIButton* stopResetButton = [testVC.view findButtonWithTitle:@"Stop"];
	XCTAssertTrue([stopResetButton isEnabled]);
}

- (void)testOnDetailViewControllerWithTimerProfilePaused_ItShowsTheResumeButtonAndSetsTheResetButtonEnabled
{
	[someViewModel setCountdownState:TimerProfileViewModelStatePaused];
	
	UIButton* startPauseButton = [testVC.view findButtonWithTitle:@"Resume"];
	XCTAssertNotNil(startPauseButton);
	
	UIButton* stopResetButton = [testVC.view findButtonWithTitle:@"Reset"];
	XCTAssertNotNil(stopResetButton);
	XCTAssertTrue([stopResetButton isEnabled]);
}

@end

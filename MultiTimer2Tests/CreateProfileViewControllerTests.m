//
//  CreateProfileViewControllerTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 02/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "UIView+FindingViews.h"
#import "UIBarButtonItem+UserInputSimulation.h"

#import "CreateProfileViewController.h"
#import "TimerProfileStore.h"

@interface CreateProfileViewControllerTests : XCTestCase {
	CreateProfileViewController* testVC;
}
@end

@implementation CreateProfileViewControllerTests

# pragma mark -
# pragma mark SetUp & TearDown

- (void)setUp
{
	NSBundle* mainBundle = [NSBundle bundleForClass:[CreateProfileViewController class]];
	UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:mainBundle];
	
    testVC = [storyBoard instantiateViewControllerWithIdentifier:@"CreateProfileViewController"];
}


# pragma mark -
# pragma mark View Configuration Tests

- (void)testViewControllerHasSomeFieldToEnterProfileName
{
	UITextField* nameField = [testVC.view findTextfieldWithPlaceHolderText:@"Profile Name"];
	XCTAssertNotNil(nameField);
}

- (void)testViewControllerHasSomeDatePickerToSelectCountdownDuration
{
	UIDatePicker* countdownPicker = [testVC.view findCountdownPickerView];
	XCTAssertNotNil(countdownPicker);
	XCTAssertEqual([countdownPicker datePickerMode], UIDatePickerModeCountDownTimer);
}

- (void)testViewControllerHasDoneButton
{
	[testVC loadView];
    UIBarButtonItem* doneButton = [testVC doneButton];
	
	XCTAssertNotNil(doneButton);
	XCTAssertEqualObjects([doneButton title], @"Done");
}

- (void)testViewControllerHasCancelButton
{
    [testVC loadView];
	UIBarButtonItem* cancelButton = [testVC cancelButton];
	
	XCTAssertNotNil(cancelButton);
	XCTAssertEqualObjects([cancelButton title], @"Cancel");
}


# pragma mark -
# pragma mark Property Tests

- (void)testViewControllerCanHasAStore
{
    TimerProfileStore* store = [[TimerProfileStore alloc] init];
	[testVC setTimerProfileStore:store];
	XCTAssertNotNil([testVC timerProfileStore]);
}


# pragma mark -
# pragma mark UI Interaction Tests

- (void)testWhenPressingDoneANewTimerProfileIsCreatedInTheStore
{
    TimerProfileStore* storeMock = OCMClassMock([TimerProfileStore class]);
	[testVC setTimerProfileStore:storeMock];
	
	[[testVC.view findTextfieldWithPlaceHolderText:@"Profile Name"] setText:@"Foo"];
	UIDatePicker* countdownPicker = [testVC.view findCountdownPickerView];
	[countdownPicker setCountDownDuration:120];
	
	[[(id)storeMock expect] createTimerProfileWithName:@"Foo" duration:120];
	
	[testVC doneButtonPressed:nil];

	[(id)storeMock verify];
}

@end

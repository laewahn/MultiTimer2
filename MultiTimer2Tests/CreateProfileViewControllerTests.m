//
//  CreateProfileViewControllerTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 02/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CreateProfileViewController.h"

@interface CreateProfileViewControllerTests : XCTestCase {
	CreateProfileViewController* testVC;
}
@end

@implementation CreateProfileViewControllerTests

- (void)setUp
{
	NSBundle* mainBundle = [NSBundle bundleForClass:[CreateProfileViewController class]];
	UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:mainBundle];
	
    testVC = [storyBoard instantiateViewControllerWithIdentifier:@"CreateProfileViewController"];
}

- (void)testViewControllerHasSomeFieldToEnterProfileName
{
	UITextField* nameField = [self findTextfieldWithPlaceHolderText:@"Profile Name" inView:[testVC view]];
	XCTAssertNotNil(nameField);
}

- (void)testViewControllerHasSomeDatePickerToSelectCountdownDuration
{
	UIDatePicker* countdownPicker = [self findCountdownPickerViewInView:[testVC view]];
	XCTAssertNotNil(countdownPicker);
	XCTAssertEqual([countdownPicker datePickerMode], UIDatePickerModeCountDownTimer);
}

- (UITextField *)findTextfieldWithPlaceHolderText:(NSString *)someText inView:(UIView *)someView
{
	ViewFilterBlock filterForTextFieldWithPlaceHolder = ^BOOL(UIView *theView) {
		return [[(UITextField *)theView placeholder] isEqualToString:someText];
	};
	return (UITextField *)[self findViewWithClass:[UITextField class] additionalFilter:filterForTextFieldWithPlaceHolder inView:someView];
}

- (UIDatePicker *)findCountdownPickerViewInView:(UIView *)someView
{
	return (UIDatePicker *)[self findViewWithClass:[UIDatePicker class] additionalFilter:nil inView:someView];
}

typedef BOOL(^ViewFilterBlock)(UIView *);

- (UIView *)findViewWithClass:(Class)someClass additionalFilter:(ViewFilterBlock)viewFilterBlock inView:(UIView *)someView
{
	UIView* theView;
	for (UIView* subView in [someView subviews]) {
		if ([subView isKindOfClass:someClass] && (viewFilterBlock ? viewFilterBlock(subView) : YES)) {
			return subView;
		} else {
			theView = [self findCountdownPickerViewInView:subView];
		}
	}
	
	return theView;
}

@end

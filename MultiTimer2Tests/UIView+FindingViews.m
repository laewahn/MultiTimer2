//
//  UIView+FindingViews.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 02/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "UIView+FindingViews.h"

@implementation UIView (FindingViews)

- (UITextField *)findTextfieldWithPlaceHolderText:(NSString *)someText
{
	ViewFilterBlock filterForTextFieldWithPlaceHolder = ^BOOL(UIView *theView) {
		return [[(UITextField *)theView placeholder] isEqualToString:someText];
	};
	return (UITextField *)[self findViewWithClass:[UITextField class] additionalFilter:filterForTextFieldWithPlaceHolder inView:self];
}

- (UIDatePicker *)findCountdownPickerView
{
	return (UIDatePicker *)[self findViewWithClass:[UIDatePicker class] additionalFilter:nil inView:self];
}

- (UIView *)findViewWithClass:(Class)someClass additionalFilter:(ViewFilterBlock)viewFilterBlock
{
	return [self findViewWithClass:someClass additionalFilter:viewFilterBlock inView:self];
}

- (UIView *)findViewWithClass:(Class)someClass additionalFilter:(ViewFilterBlock)viewFilterBlock inView:(UIView *)someView
{
	UIView* theView;
	for (UIView* subView in [someView subviews]) {
		if ([subView isKindOfClass:someClass] && (viewFilterBlock ? viewFilterBlock(subView) : YES)) {
			return subView;
		} else {
			theView = [self findViewWithClass:someClass additionalFilter:viewFilterBlock inView:subView];
		}
	}
	
	return theView;
}

@end

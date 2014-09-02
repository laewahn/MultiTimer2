//
//  UIView+FindingViews.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 02/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^ViewFilterBlock)(UIView *);

@interface UIView (FindingViews)

- (UITextField *)findTextfieldWithPlaceHolderText:(NSString *)someText;
- (UIDatePicker *)findCountdownPickerView;

- (UIView *)findViewWithClass:(Class)someClass additionalFilter:(ViewFilterBlock)viewFilterBlock;

@end

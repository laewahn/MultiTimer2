//
//  TimerAlert.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 18/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "TimerAlert.h"

@implementation TimerAlert

- (UIAlertView *)alertView
{
	if (_alertView == nil) {
		_alertView = [[UIAlertView alloc] init];
	}
	
	return _alertView;
}

@end

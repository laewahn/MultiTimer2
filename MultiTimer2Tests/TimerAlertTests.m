//
//  TimerAlertTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 18/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TimerAlert.h"

@interface TimerAlertDefaultsTests : XCTestCase
@end

@implementation TimerAlertDefaultsTests

- (void)testOnTimerAlert_ItHasADefaultAlertView
{
    TimerAlert* testAlert = [[TimerAlert alloc] init];
	XCTAssertNotNil([testAlert alertView]);
}

@end


@interface TimerAlertTests : XCTestCase
@end

@implementation TimerAlertTests

- (void)testOnTimerAlert_ItHasAnAlertView
{
    TimerAlert* testAlert = [[TimerAlert alloc] init];

	UIAlertView* someAlertView = [[UIAlertView alloc] init];
	[testAlert setAlertView:someAlertView];
	XCTAssertNotNil([testAlert alertView]);
}

@end

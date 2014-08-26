//
//  TimerOverviewViewControllerTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 26/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TimerOverviewViewController.h"

@interface TimerOverviewViewControllerTests : XCTestCase

@end

@implementation TimerOverviewViewControllerTests

- (void)testOverviewControllerHasManagedObjectContextAfterInitialization
{
	NSBundle* mainBundle = [NSBundle bundleForClass:[TimerOverviewViewController class]];
	UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:mainBundle];
	
    TimerOverviewViewController* testVC = [storyBoard instantiateViewControllerWithIdentifier:@"TimerOverviewViewController"];
	XCTAssertNotNil([testVC managedObjectContext]);
}

@end

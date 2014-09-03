//
//  DetailViewControllerTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 03/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DetailViewController.h"

@interface DetailViewControllerTests : XCTestCase

@end

@implementation DetailViewControllerTests

- (void)testDetailViewControllerHasStartButton
{
    NSBundle* mainBundle = [NSBundle bundleForClass:[DetailViewController class]];
	UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:mainBundle];
	
	DetailViewController* testVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
	[testVC loadView];
	
	UIButton* startButton = [testVC startPauseButton];
	XCTAssertNotNil(startButton);
}

@end

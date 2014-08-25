//
//  TimerProfileViewModelTests.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTest+CoreDataTestStack.h"

#import "TimerProfileViewModel.h"
#import "TimerProfile.h"

@interface TimerProfileViewModelTests : XCTestCase

@end

@implementation TimerProfileViewModelTests

- (void)testTimerProfileViewModelCanBeInitializedWithTimerProfile
{
	TimerProfile* testProfile = [TimerProfile createWithManagedObjectContext:[self managedObjectTestContext]];
	
    TimerProfileViewModel* testViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:testProfile];
	XCTAssertNotNil(testViewModel);
	XCTAssertEqualObjects([testViewModel timerProfile], testProfile, @"Should have the TimerProfile");
}

@end

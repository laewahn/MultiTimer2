//
//  TimerProfileViewModel.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "TimerProfileViewModel.h"

#import "TimerProfile.h"


@interface TimerProfileViewModel() {
	TimerProfile* _timerProfile;
}
@end

@implementation TimerProfileViewModel

- (instancetype)initWithTimerProfile:(TimerProfile *)timerProfile
{
	self = [super init];
	
	if (self != nil) {
		_timerProfile = timerProfile;
	}
	
	return self;
}

- (NSString *)name
{
	return [self.timerProfile name];
}

- (NSString *)duration
{
	NSInteger durationInSeconds = floor([self.timerProfile duration]);
	
	NSInteger seconds = durationInSeconds % 60;
	NSInteger minutes = durationInSeconds / 60;

	return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

@end

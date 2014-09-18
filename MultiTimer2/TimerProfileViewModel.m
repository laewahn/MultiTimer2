//
//  TimerProfileViewModel.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "TimerProfileViewModel.h"

#import "TimerProfile.h"

void * TimerProfileRemainingTimeContext = &TimerProfileRemainingTimeContext;

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
		[_timerProfile addObserver:self forKeyPath:@"remainingTime" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:TimerProfileRemainingTimeContext];
		[_timerProfile addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:TimerProfileRemainingTimeContext];

	}
	
	return self;
}

- (void)dealloc
{
	[_timerProfile removeObserver:self forKeyPath:@"remainingTime"];
	[_timerProfile removeObserver:self forKeyPath:@"running"];
}

- (void) updateState
{
	if ([_timerProfile isRunning]) {
		_countdownState = TimerProfileViewModelStateRunning;
	} else {
		if ([_timerProfile remainingTime] == [_timerProfile duration]) {
			_countdownState = TimerProfileViewModelStateStopped;
		} else if ([_timerProfile remainingTime] == 0) {
			_countdownState = TimerProfileViewModelStateExpired;
		} else {
			_countdownState = TimerProfileViewModelStatePaused;
		}
	}
}

- (void) startCountdown
{
	[self.timerProfile startCountdown];
}

- (void) stopCountdown
{
	[self.timerProfile stopCountdown];
}

- (void) pauseCountdown
{
	[self.timerProfile pauseCountdown];
}

- (NSString *)name
{
	return [self.timerProfile name];
}

- (NSString *)duration
{
	NSTimeInterval durationToDisplay = [self.timerProfile remainingTime];

	NSInteger seconds = floor(durationToDisplay);
	NSInteger minutes = seconds / 60;
	NSInteger hours = minutes/60;
	
	NSString* timeString = [NSString stringWithFormat:@"%02d:%02d", minutes % 60, seconds % 60];
	
	if (hours != 0) {
		timeString = [NSString stringWithFormat:@"%d:%@", hours, timeString];
	}

	return timeString;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	[self willChangeValueForKey:@"duration"];
	[self willChangeValueForKey:@"countdownState"];
	
	[self updateState];
	
	[self didChangeValueForKey:@"duration"];
	[self didChangeValueForKey:@"countdownState"];
}

@end

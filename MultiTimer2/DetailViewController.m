//
//  DetailViewController.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "DetailViewController.h"

#import "TimerProfileViewModel.h"

void * TimerProfileViewControllerChangeContext = &TimerProfileViewControllerChangeContext;

@interface DetailViewController ()
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setTitle:[self.timerProfileViewModel name]];
	[self updateView];
}

- (void)setTimerProfileViewModel:(TimerProfileViewModel *)timerProfileViewModel
{
	[_timerProfileViewModel removeObserver:self forKeyPath:@"duration"];
	[_timerProfileViewModel removeObserver:self forKeyPath:@"countdownState"];
	
	_timerProfileViewModel = timerProfileViewModel;
	
	[_timerProfileViewModel addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:TimerProfileViewControllerChangeContext];
	[_timerProfileViewModel addObserver:self forKeyPath:@"countdownState" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:TimerProfileViewControllerChangeContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == TimerProfileViewControllerChangeContext) {
		[self updateView];
	}
}

- (void)updateView
{
	[self.durationLabel setText:[self.timerProfileViewModel duration]];
	
	if ([self.timerProfileViewModel countdownState] == TimerProfileViewModelStateStopped) {
		[self.startPauseButton setTitle:@"Start" forState:UIControlStateNormal];
		[self.stopResetButton setTitle:@"Stop" forState:UIControlStateNormal];
		[self.stopResetButton setEnabled:NO];
	} else if ([self.timerProfileViewModel countdownState] == TimerProfileViewModelStateRunning) {
		[self.startPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
		[self.stopResetButton setTitle:@"Stop" forState:UIControlStateNormal];
		[self.stopResetButton setEnabled:YES];
	} else if ([self.timerProfileViewModel countdownState] == TimerProfileViewModelStatePaused) {
		[self.startPauseButton setTitle:@"Resume" forState:UIControlStateNormal];
		[self.stopResetButton setTitle:@"Reset" forState:UIControlStateNormal];
		[self.stopResetButton setEnabled:YES];
	}
}

- (IBAction)startPauseButtonPressed:(id)sender
{
	[self.timerProfileViewModel startCountdown];
}

@end

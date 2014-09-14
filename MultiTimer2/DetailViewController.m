//
//  DetailViewController.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "DetailViewController.h"

#import "TimerProfileViewModel.h"

void * TimerProfileViewControllerDurationContext = &TimerProfileViewControllerDurationContext;

@interface DetailViewController ()
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setTitle:[self.timerProfileViewModel name]];
}

- (void)setTimerProfileViewModel:(TimerProfileViewModel *)timerProfileViewModel
{
	[_timerProfileViewModel removeObserver:self forKeyPath:@"duration"];
	
	_timerProfileViewModel = timerProfileViewModel;
	
	[_timerProfileViewModel addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:TimerProfileViewControllerDurationContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	
}

@end

//
//  TimerProfileTableViewCell.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 15/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "TimerProfileTableViewCell.h"

#import "TimerProfileViewModel.h"

@implementation TimerProfileTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
	[_viewModel removeObserver:self forKeyPath:@"duration"];
	[_viewModel removeObserver:self forKeyPath:@"name"];
}

- (void)setViewModel:(TimerProfileViewModel *)viewModel
{
	[_viewModel removeObserver:self forKeyPath:@"duration"];
	[_viewModel removeObserver:self forKeyPath:@"name"];
	
	_viewModel = viewModel;
	
	[_viewModel addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:TimerProfileRemainingTimeContext];
	[_viewModel addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:TimerProfileRemainingTimeContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"duration"]) {
		NSString* updatedDuration = change[NSKeyValueChangeNewKey];
		[self.durationLabel setText:updatedDuration];
	} else if ([keyPath isEqualToString:@"name"]) {
		NSString* updatedName = change[NSKeyValueChangeNewKey];
		[self.nameLabel setText:updatedName];
	}
}

@end

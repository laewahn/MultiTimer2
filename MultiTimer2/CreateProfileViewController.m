//
//  CreateProfileViewController.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 02/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "CreateProfileViewController.h"

#import "TimerProfileStore.h"

@implementation CreateProfileViewController

- (void)viewDidAppear:(BOOL)animated
{
	[self.profileNameTextField setDelegate:self];
	[self.profileNameTextField becomeFirstResponder];
	
	[super viewDidAppear:animated];
}

- (IBAction)doneButtonPressed:(id)sender
{
	[self createNewTimerProfile];
}

- (IBAction)cancelButtonPressed:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textFieldFinished:(id)sender
{
	[self createNewTimerProfile];
}

- (void)createNewTimerProfile
{
	NSString* newProfileName = [self.profileNameTextField text];
	NSTimeInterval newProfileDuration = [self.profileDurationPicker countDownDuration];
	
	[self.timerProfileStore createTimerProfileWithName:newProfileName duration:newProfileDuration];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}



@end

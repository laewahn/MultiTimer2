//
//  CreateProfileViewController.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 02/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "CreateProfileViewController.h"

@implementation CreateProfileViewController

- (void)viewDidAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.profileNameTextField becomeFirstResponder];
}

@end

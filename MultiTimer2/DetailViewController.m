//
//  DetailViewController.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "DetailViewController.h"

#import "TimerProfile.h"

@interface DetailViewController ()
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setTitle:[self.profile name]];
}

@end

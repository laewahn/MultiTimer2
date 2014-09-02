//
//  UIBarButtonItem+UserInputSimulation.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 02/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "UIBarButtonItem+UserInputSimulation.h"

@implementation UIBarButtonItem (UserInputSimulation)

- (void)simulateTap
{
	[self.target performSelectorOnMainThread:[self action] withObject:self waitUntilDone:YES];
	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
}

@end

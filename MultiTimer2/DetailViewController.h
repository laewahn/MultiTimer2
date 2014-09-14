//
//  DetailViewController.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimerProfileViewModel;

@interface DetailViewController : UIViewController

@property (nonatomic, strong) TimerProfileViewModel* timerProfileViewModel;

@property (weak, nonatomic) IBOutlet UIButton* startPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopResetButton;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

- (IBAction)startPauseButtonPressed:(id)sender;

@end

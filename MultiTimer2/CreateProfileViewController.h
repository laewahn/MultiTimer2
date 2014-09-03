//
//  CreateProfileViewController.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 02/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimerProfileStore;

@interface CreateProfileViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic, strong) IBOutlet UITextField* profileNameTextField;
@property(nonatomic, strong) IBOutlet UIDatePicker* profileDurationPicker;

@property(nonatomic, strong) IBOutlet UIBarButtonItem* doneButton;
@property(nonatomic, strong) IBOutlet UIBarButtonItem* cancelButton;

@property(nonatomic, strong) TimerProfileStore* timerProfileStore;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)textFieldFinished:(id)sender;

@end

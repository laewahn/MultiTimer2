//
//  TimerProfileTableViewCell.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 15/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimerProfileViewModel;

@interface TimerProfileTableViewCell : UITableViewCell

@property(nonatomic, strong) TimerProfileViewModel* viewModel;

@end

//
//  TimerOverviewViewController.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@class TimerProfileStore;

@interface TimerOverviewViewController : UITableViewController

@property(nonatomic, strong) IBOutlet TimerProfileStore* timerProfileStore;

@end

//
//  TimerOverviewViewController.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "FetchedResultsDataSource.h"

@class TimerProfileStore;

@interface TimerOverviewViewController : UITableViewController <FetchedResultsDataSourceDelegate>

@property(nonatomic, strong) TimerProfileStore* timerProfileStore;
@property(nonatomic, strong) IBOutlet UIBarButtonItem* addButton;

- (IBAction)createNewProfile:(id)sender;

@end

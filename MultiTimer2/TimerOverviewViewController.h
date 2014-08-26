//
//  TimerOverviewViewController.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface TimerOverviewViewController : UITableViewController

@property(readonly) NSManagedObjectContext* managedObjectContext;

@end

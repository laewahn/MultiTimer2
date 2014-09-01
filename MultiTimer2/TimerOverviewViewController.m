//
//  TimerOverviewViewController.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "TimerOverviewViewController.h"

#import "DetailViewController.h"
#import "FetchedResultsDataSource.h"
#import "TimerProfileStore.h"

@interface TimerOverviewViewController ()
@end

@implementation TimerOverviewViewController

- (void)awakeFromNib
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
	self.navigationItem.rightBarButtonItem = addButton;
}

- (void)setTimerProfileStore:(TimerProfileStore *)timerProfileStore
{
	_timerProfileStore = timerProfileStore;
	
	FetchedResultsDataSource* dataSource = (FetchedResultsDataSource *)[self.tableView dataSource];
	[dataSource setFetchedResultsController:[_timerProfileStore timerProfilesFetchedResultsController]];
	[dataSource setCellReuseIdentifier:@"Cell"];
	
	[self.tableView reloadData];
}

- (void)insertNewObject:(id)sender
{

}

@end

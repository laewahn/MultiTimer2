//
//  TimerOverviewViewController.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "TimerOverviewViewController.h"

#import "DetailViewController.h"
#import "TimerProfileViewModel.h"
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

	FetchedResultsDataSource* dataSource = (FetchedResultsDataSource *)[self.tableView dataSource];
	[dataSource setDelegate:self];
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

- (void)configureCell:(UITableViewCell *)someCell withObject:(id)someObject
{
	TimerProfileViewModel* tpViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:someObject];
	
	[someCell.textLabel setText:[tpViewModel name]];
	[someCell.detailTextLabel setText:[tpViewModel duration]];
}

@end

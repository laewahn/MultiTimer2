//
//  TimerOverviewViewController.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "TimerOverviewViewController.h"

#import "TimerProfileViewModel.h"
#import "TimerProfileStore.h"

#import "CreateProfileViewController.h"
#import "DetailViewController.h"

@interface TimerOverviewViewController ()
@end

@implementation TimerOverviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	FetchedResultsDataSource* dataSource = (FetchedResultsDataSource *)[self.tableView dataSource];
	[dataSource setDelegate:self];
	[dataSource setTableView:[self tableView]];
}

- (void)setTimerProfileStore:(TimerProfileStore *)timerProfileStore
{
	_timerProfileStore = timerProfileStore;
	
	FetchedResultsDataSource* dataSource = (FetchedResultsDataSource *)[self.tableView dataSource];
	[dataSource setFetchedResultsController:[_timerProfileStore timerProfilesFetchedResultsController]];
	
	[dataSource setCellReuseIdentifier:@"Cell"];
	
	[self.tableView reloadData];
}

- (void)configureCell:(UITableViewCell *)someCell withObject:(id)someObject
{
	TimerProfileViewModel* tpViewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:someObject];
	
	[someCell.textLabel setText:[tpViewModel name]];
	[someCell.detailTextLabel setText:[tpViewModel duration]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"CreateTimerProfileSegue"]) {
		CreateProfileViewController* createVC = [segue destinationViewController];
		[createVC setTimerProfileStore:[self timerProfileStore]];
	}
	
	if ([segue.identifier isEqualToString:@"showDetail"]) {
		DetailViewController* detailVC = [segue destinationViewController];
		
		NSIndexPath* selectionIndexPath = [self.tableView indexPathForSelectedRow];
		TimerProfile* selectedProfile = [self.timerProfileStore.timerProfilesFetchedResultsController objectAtIndexPath:selectionIndexPath];
		
		TimerProfileViewModel* viewModel = [[TimerProfileViewModel alloc] initWithTimerProfile:selectedProfile];
		[detailVC setTimerProfileViewModel:viewModel];
	}
}

@end

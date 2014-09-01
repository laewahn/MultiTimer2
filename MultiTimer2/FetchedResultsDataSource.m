//
//  FetchedResultsDataSource.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "FetchedResultsDataSource.h"

@implementation FetchedResultsDataSource

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
	_fetchedResultsController = fetchedResultsController;
	
	NSError* fetchError;
	[_fetchedResultsController performFetch:&fetchError];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.fetchedResultsController.sections count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cellToConfigure = [tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier]];
	
	id objectForConfiguration = [self.fetchedResultsController objectAtIndexPath:indexPath];
		
	[self.delegate configureCell:cellToConfigure withObject:objectForConfiguration];
	
	return cellToConfigure;
}

@end

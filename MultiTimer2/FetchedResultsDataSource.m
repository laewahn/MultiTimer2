//
//  FetchedResultsDataSource.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "FetchedResultsDataSource.h"

@implementation FetchedResultsDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.fetchedResultsController.sections count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray* rows = [self.fetchedResultsController.sections objectAtIndex:section];
	return [rows count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cellToConfigure = [tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier]];
	
	if ([self cellConfigurationBlock]) {
		id objectForConfiguration = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[self cellConfigurationBlock](cellToConfigure, objectForConfiguration);
	}

	return cellToConfigure;
}

@end

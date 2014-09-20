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
	
	[_fetchedResultsController setDelegate:self];
	
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObject* objectToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[objectToDelete.managedObjectContext deleteObject:objectToDelete];
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	id objectForDeletion = [self.fetchedResultsController objectAtIndexPath:indexPath];
	return [self.delegate canDeleteObject:objectForDeletion];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	[self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
	if (type == NSFetchedResultsChangeInsert) {
		[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	
	if (type == NSFetchedResultsChangeDelete) {
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	
}

@end

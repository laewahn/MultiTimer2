//
//  XCTest+CoreDataTestStack.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "XCTest+CoreDataTestStack.h"

#import "AppDelegate.h"

@implementation XCTest (CoreDataTestStack)

- (NSManagedObjectContext *)managedObjectTestContext
{
	NSManagedObjectContext* testManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	
	NSBundle* resourceBundle = [NSBundle bundleForClass:[AppDelegate class]];
	NSURL* modelURL = [resourceBundle URLForResource:@"MultiTimer2" withExtension:@"momd"];
	
	NSManagedObjectModel* model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	NSPersistentStoreCoordinator* storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	
	[testManagedObjectContext setPersistentStoreCoordinator:storeCoordinator];
	
	return testManagedObjectContext;
}

- (NSManagedObjectContext *)managedObjectTestContextWithTimerProfileNamed:(NSString *)name duration:(NSTimeInterval)duration
{
	NSManagedObjectContext* context = [self managedObjectTestContext];
	NSManagedObject* someProfile = [NSEntityDescription insertNewObjectForEntityForName:@"TimerProfile" inManagedObjectContext:context];
	
	[someProfile setValue:name forKey:@"name"];
	[someProfile setPrimitiveValue:@(duration) forKey:@"duration"];
	
	return context;
}


@end

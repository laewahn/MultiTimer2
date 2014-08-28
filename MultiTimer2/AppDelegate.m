//
//  AppDelegate.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "AppDelegate.h"

#import "TimerOverviewViewController.h"
#import "FetchedResultsDataSource.h"
#import "TimerProfileStore.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override point for customization after application launch.
	UINavigationController* navigationController = (UINavigationController *)[self.window rootViewController];
	TimerOverviewViewController* overviewVC = (TimerOverviewViewController *)[navigationController topViewController];
	TimerProfileStore* store = [[TimerProfileStore alloc] init];
	[store setManagedObjectContext:[self managedObjectContext]];
	[overviewVC setTimerProfileStore:store];
	
    return YES;
}

- (NSManagedObjectContext *)managedObjectContext
{
	if(_managedObjectContext == nil) {
		NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"MultiTimer2" withExtension:@"momd"];
		NSManagedObjectModel* model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
		
		NSPersistentStoreCoordinator* persistenStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
		NSURL* sqliteStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MultiTimer2.sqlite"];
		NSError* error;
		[persistenStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
												configuration:nil
														  URL:sqliteStoreURL
													  options:nil
														error:&error];
		
		NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		[context setPersistentStoreCoordinator:persistenStoreCoordinator];
		
		_managedObjectContext = context;
	}
	
	
	return _managedObjectContext;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

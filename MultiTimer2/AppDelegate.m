//
//  AppDelegate.m
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "AppDelegate.h"

#import "TimerOverviewViewController.h"
#import "TimerProfileStore.h"
#import "TimerProfile.h"
#import "TimerAlert.h"
#import "TimerController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
		[application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
	}
	
	UINavigationController* navigationController = (UINavigationController *)[self.window rootViewController];
		
	TimerOverviewViewController* overviewVC = (TimerOverviewViewController *)[navigationController topViewController];
	[overviewVC setTimerProfileStore:[self timerProfileStore]];
	
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	if ([application applicationState] == UIApplicationStateActive) {
		NSURL* expiredTimerURL = [NSURL URLWithString:[notification.userInfo valueForKey:@"timerProfileURI"]];
		NSManagedObjectID* expiredTimerID = [self.managedObjectContext.persistentStoreCoordinator managedObjectIDForURIRepresentation:expiredTimerURL];
		
		NSError* restoreTimerError;
		TimerProfile* expiredTimer = (TimerProfile *)[self.managedObjectContext existingObjectWithID:expiredTimerID error:&restoreTimerError];
		
		[self handleExpiredTimer:expiredTimer];
	}
}

- (void)handleExpiredTimer:(TimerController *)timerController
{
	[timerController pauseTimer];
	
	[self.timerAlert setTitle:[timerController.profile name]];
	[self.timerAlert show];
	[self.timerAlert setTimerController:timerController];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	for (TimerProfile* expiredTimer in [self.timerProfileStore fetchExpiredTimerProfiles]) {
        // TODO: Need a clever way to create controllers for timers
//		[expiredTimer stopTimer];
	}
	
	for (TimerProfile* profile in [self.timerProfileStore fetchTimerProfiles]) {
		if ([profile isRunning]) {
			NSDate* now = [NSDate date];
			NSTimeInterval updatedRemainingTime = [profile.expirationDate timeIntervalSinceDate:now];
			[profile setRemainingTime:updatedRemainingTime];
		}
	}
}

- (TimerAlert *)timerAlert
{
	if (_timerAlert == nil) {
		_timerAlert = [[TimerAlert alloc] initWithTitle:nil message:@"Timer expired." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
	}
	
	return _timerAlert;
}

- (TimerProfileStore *)timerProfileStore
{
	if (_timerProfileStore == nil) {
		_timerProfileStore = [[TimerProfileStore alloc] init];
		[_timerProfileStore setManagedObjectContext:[self managedObjectContext]];
	}
	
	return _timerProfileStore;
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[[(TimerAlert *)alertView timerController] stopTimer];
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

//
//  AppDelegate.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimerProfile;
@class TimerProfileStore;
@class TimerAlert;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) TimerProfileStore* timerProfileStore;

@property (strong, nonatomic) TimerAlert* timerAlert;

- (void)handleExpiredTimer:(TimerProfile *)timer;
- (NSURL *)applicationDocumentsDirectory;

@end

//
//  TimerProfile.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CountdownNotificationScheduler;

@interface TimerProfile : NSManagedObject

+ (instancetype) createWithName:(NSString *)profileName duration:(NSTimeInterval)profileDuration managedObjectContext:(NSManagedObjectContext *)context;

- (void)startCountdown;
- (void)stopCountdown;
- (void)pauseCountdown;

@property (nonatomic, readonly) NSURL* managedObjectIDAsURI;
@property (nonatomic, retain) NSString* name;
@property (nonatomic) double duration;

@property (nonatomic) BOOL isRunning;
@property (nonatomic) NSTimeInterval remainingTime;

@property (nonatomic, strong) CountdownNotificationScheduler* notificationScheduler;

@end

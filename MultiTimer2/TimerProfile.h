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

- (void)startTimer;
- (void)stopTimer;
- (void)pauseTimer;

@property (nonatomic, readonly) NSURL* managedObjectIDAsURI;
@property (nonatomic, retain) NSString* name;
@property (nonatomic) double duration;
@property (nonatomic, retain) NSDate* expirationDate;

@property (nonatomic, getter = isRunning) BOOL running;
@property (nonatomic) NSTimeInterval remainingTime;
@property (nonatomic, strong) NSTimer* countdownTimer;

@property (nonatomic, strong) CountdownNotificationScheduler* notificationScheduler;

@end

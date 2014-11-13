//
//  TimerController.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 13/11/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TimerProfile;
@class CountdownNotificationScheduler;


@interface TimerController : NSObject

- (void)startTimer;
- (void)stopTimer;
- (void)pauseTimer;

@property (nonatomic, strong) NSTimer* countdownTimer;
@property(strong) TimerProfile* profile;
@property (nonatomic, strong) CountdownNotificationScheduler* notificationScheduler;

@end

//
//  CountdownNotificationManager.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 14/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TimerProfile;

@interface CountdownNotificationManager : NSObject

- (void)scheduleCountdownExpiredNoficationIn:(NSTimeInterval)timeInterval secondsForTimer:(TimerProfile *)timer;

- (void)cancelScheduledNotification;

@end

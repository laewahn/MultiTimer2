//
//  TimerAlert.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 18/09/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TimerProfile;

@interface TimerAlert : UIAlertView

@property(nonatomic, strong) TimerProfile* timer;

@end

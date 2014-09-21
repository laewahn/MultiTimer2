//
//  TimerProfileStore.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 26/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TimerProfile;

@interface TimerProfileStore : NSObject

- (TimerProfile *)createTimerProfileWithName:(NSString *)name duration:(NSTimeInterval)duration;

- (NSArray *)fetchTimerProfiles;
- (NSArray *)fetchExpiredTimerProfiles;

@property(nonatomic, readonly) NSFetchedResultsController*  timerProfilesFetchedResultsController;
@property(nonatomic, strong) NSManagedObjectContext* managedObjectContext;

@end

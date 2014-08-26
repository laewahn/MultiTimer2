//
//  TimerProfileStore.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 26/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerProfileStore : NSObject

@property(nonatomic, strong) NSManagedObjectContext* managedObjectContext;

@end

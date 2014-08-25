//
//  TimerProfile.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimerProfile : NSManagedObject

+ (instancetype) createWithManagedObjectContext:(NSManagedObjectContext *)context;

+ (instancetype) createWithName:(NSString *)profileName duration:(NSTimeInterval)profileDuration managedObjectContext:(NSManagedObjectContext *)context;


@property (nonatomic, retain) NSString * name;
@property (nonatomic) double duration;

@end

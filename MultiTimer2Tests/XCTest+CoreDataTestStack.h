//
//  XCTest+CoreDataTestStack.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTest (CoreDataTestStack)

- (NSManagedObjectContext *)managedObjectTestContext;

@end

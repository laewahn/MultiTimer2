//
//  FetchedResultsDataSource.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FetchedResultsDataSourceDelegate <NSObject>
- (void) configureCell:(UITableViewCell *)someCell withObject:(id)someObject;
@end

@interface FetchedResultsDataSource : NSObject<UITableViewDataSource>

@property(nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property(nonatomic, strong) NSString* cellReuseIdentifier;

@property(nonatomic, weak) id<FetchedResultsDataSourceDelegate> delegate;

@end

//
//  FetchedResultsDataSource.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^FetchedResultsDataSourceCellConfigurationBlock)(UITableViewCell* cell, id object);

@interface FetchedResultsDataSource : NSObject<UITableViewDataSource>

@property(nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property(nonatomic, strong) NSString* cellReuseIdentifier;
@property(nonatomic, strong) FetchedResultsDataSourceCellConfigurationBlock cellConfigurationBlock;

@end

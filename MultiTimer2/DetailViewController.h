//
//  DetailViewController.h
//  MultiTimer2
//
//  Created by Dennis Lewandowski on 25/08/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimerProfile;

@interface DetailViewController : UIViewController

@property (nonatomic, strong) TimerProfile* profile;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

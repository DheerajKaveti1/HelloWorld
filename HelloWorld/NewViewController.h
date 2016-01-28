//
//  NewViewController.h
//  HelloWorld
//
//  Created by Kaveti, Dheeraj on 1/15/16.
//  Copyright © 2016 DPSG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface NewViewController : UIViewController
+ (NewViewController*)sharedInstance;

@property (nonatomic, strong) FMDatabaseQueue                     *   databaseQ;
@property (nonatomic, strong) FMDatabase                          *   database;
@end

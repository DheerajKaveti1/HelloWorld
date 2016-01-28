//
//  ViewController.h
//  HelloWorld
//
//  Created by Kaveti, Dheeraj on 1/15/16.
//  Copyright © 2016 DPSG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"
@interface ViewController : UIViewController<RATreeViewDelegate,RATreeViewDataSource>
@property (strong, nonatomic) NSArray *data;
@end


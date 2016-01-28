//
//  EBHObject.h
//  HelloWorld
//
//  Created by Kaveti, Dheeraj on 1/27/16.
//  Copyright © 2016 DPSG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBHObject : NSObject
@property (nonatomic, assign) NSUInteger    EBID;
@property (nonatomic, assign) NSUInteger    isActive;
@property (nonatomic, assign) NSUInteger    parentId;
@property (nonatomic, strong) NSString*     BCNodeId;
@property (nonatomic, strong) NSString*     nodeType;
@property (nonatomic, strong) NSString*     nodeDesc;
@property (nonatomic, strong) NSString*     EBName;
@property (nonatomic, strong) NSString*     EBType;
@end

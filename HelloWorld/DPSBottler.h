//
//  DPSBottler.h
//  DPSBCMyDay
//
//  Created by Modugu, Surendar on 3/6/14.
//  Copyright (c) 2014 DPSG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPSBottler : NSCoder

@property (nonatomic, assign) NSUInteger    bottlerId;
@property (nonatomic, strong) NSString*     bcBottlerId;
@property (nonatomic, strong) NSString*     name;
@property (nonatomic, assign) NSUInteger    channelId;
@property (nonatomic, assign) NSUInteger    statusId;
@property (nonatomic, assign) NSUInteger    bcRegionId;
@property (nonatomic, strong) NSString*     address;
@property (nonatomic, strong) NSString*     city;
@property (nonatomic, strong) NSString*     state;
@property (nonatomic, strong) NSString*     postalCode;
@property (nonatomic, strong) NSString*     country;
@property (nonatomic, strong) NSString*     email;
@property (nonatomic, strong) NSString*     phoneNumber;
@property (nonatomic, assign) float         longitude;
@property (nonatomic, assign) float         latitude;
@property (nonatomic, assign) BOOL          isActive;
@property (nonatomic, strong) NSDate*       updatedTime;

@property (nonatomic, strong) NSArray*      trademarksList;

@property (nonatomic, strong) NSDate*       promoLastSyncTime;
@property (nonatomic, strong) NSDate*       storesLastSyncTime;
@property (nonatomic, strong) NSDate*       historyLastSyncTime;

@property (nonatomic, strong) NSString*     searchHash;
@property (nonatomic, assign) NSUInteger    EBID;

- (NSString*)getFullAddress;
- (void)createSearchHash;

@end

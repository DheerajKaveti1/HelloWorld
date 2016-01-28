//
//  DPSBottler.m
//  DPSBCMyDay
//
//  Created by Modugu, Surendar on 3/6/14.
//  Copyright (c) 2014 DPSG. All rights reserved.
//

#import "DPSBottler.h"
#import "DPSUtilities.h"

@implementation DPSBottler

//NSUInteger    bottlerId;
//NSString*     bcBottlerId;
//NSString*     name;
//NSUInteger    channelId;
//NSUInteger    statusId;
//NSUInteger    bcRegionId;
//NSString*     address;
//NSString*     city;
//NSString*     state;
//NSString*     postalCode;
//NSString*     country;
//NSString*     email;
//NSString*     phoneNumber;
//float         longitude;
//float         latitude;
//NSDate*       updatedTime;

- (NSString*)getFullAddress {
    return [NSString stringWithFormat:@"%@, %@, %@, %@", _address, _city, _state, _postalCode];
}


- (void)createSearchHash {
    _searchHash = [NSString stringWithFormat:@"%@,%@,%@", _name, [self getFullAddress], _phoneNumber];
}

@end

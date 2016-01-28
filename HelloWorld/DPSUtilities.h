//
//  DPSUitilities.h
//  DPSBCMyDay
//
//  Created by Modugu, Surendar on 3/20/14.
//  Copyright (c) 2014 DPSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DPSUtilities : NSObject

+ (NSString*)stringFromInteger:(NSInteger)integerValue;
+ (NSString*)stringFromBoolString:(NSString*)boolString;
+ (NSString*)stringFromDouble:(float)floatValue;

+ (NSString*)stringFromIntString:(id)stringObject;

+ (NSString*)relativeDateStringFromDate:(NSDate*)date;
+ (NSString*)stringFromSyncDateTime:(NSDate*)date;
+ (NSString*)relativeStringFromRefreshSyncDateTime:(NSDate*)date;



+ (NSString*)getSystemName:(NSString*)nameString;

+ (NSString*)stringFromDate:(NSDate*)date;
+ (NSString*)stringFromModifiedDate:(NSDate*)date;
+ (NSDate*)dateFromString:(NSString*)dateString;
//+ (NSString*)UTCDateStringFromDate:(NSDate*)date;

+ (NSString*)stringFromDateTime:(NSDate*)date;
+ (NSDate*)today;
+ (NSDate*)defaultSyncDate;
+ (NSString*)todayString;
+ (NSString*)getSurveyReportDateString;

+ (NSString*)stringFromPromoDate:(NSString*)dateString;
+ (NSString*)stringFromPromoAttachmentDate:(NSString*)dateString;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

+ (NSString*)stringFromPriorityDate:(NSString*)dateString;

//+ (NSString*)saveImage:(UIImage*)image;
//+ (UIImage*)getSavedImage:(NSString*)imageName;
//+ (void)removeSavedImage:(NSString*)imageName;
//+ (void)renameSavedImage:(NSString*)imageName with:(NSString*)newImageName;

+ (NSString*)getHistoryTieInDate:(NSString*)dateString;

+ (void)trackLoginIntoGA;
+ (void)trackGAEvent:(NSString*)eventAction label:(NSString*)eventLabel screenName:(NSString*)screenName;
+ (void)trackLoadTimingIntoGA:(NSString*)name time:(NSTimeInterval)timeInterval;

+ (NSInteger)integerFromString:(id)intObject;
+ (double)doubleFromString:(id)intObject;
+ (NSString*)stringFromString:(id)stringObject;

+ (NSString*)getImageBase64Bytes:(UIImage*)image;

+ (NSString*)stringFromConditionDate:(NSString*)dateString;

+ (NSString*)getConditionDateStringFromString:(NSString*)dateString relative:(BOOL)relative;

+ (NSString*)stringFromModifiedString:(NSString*)dateString format:(NSString*)dateFormat;
+ (NSString*)modifiedStringFromDate:(NSDate*)date;
+ (NSString*)stringFromRefreshSyncDateTime:(NSDate*)date ;
+ (void)trackConnectionTypeIntoGA:(NSString*)fromModule screenName:(NSString*)screenName count:(NSUInteger)count;

+ (void)trackNetworkError:(NSString*)serviceName error:(NSString*)error;
+ (void)trackServerError:(NSString*)serviceName error:(NSString*)error;

@end

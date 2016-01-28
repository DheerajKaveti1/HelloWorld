//
//  DPSUitilities.m
//  DPSBCMyDay
//
//  Created by Modugu, Surendar on 3/20/14.
//  Copyright (c) 2014 DPSG. All rights reserved.
//

#import "DPSUtilities.h"

#import <MapKit/MapKit.h>
#import <AFNetworkReachabilityManager.h>

@implementation DPSUtilities

+ (NSString*)stringFromInteger:(NSInteger)integerValue {
    return [NSString stringWithFormat:@"%d", integerValue];
}

+ (NSString*)stringFromDouble:(float)floatValue {
    return [NSString stringWithFormat:@"%f", floatValue];
}

+ (NSString*)stringFromBoolString:(NSString*)boolString {
    if ([[boolString uppercaseString] isEqualToString:@"TRUE"]) {
        return @"1";
    }
    return @"0";
}



+ (NSString*)getSystemName:(NSString*)nameString {
    NSRange dashRange   = [nameString rangeOfString:@"- "];
    if (dashRange.location != NSNotFound) {
        nameString  = [nameString substringFromIndex:dashRange.location+dashRange.length];
    }
    
    NSRange spaceRange  = [nameString rangeOfString:@" "];
    if (spaceRange.location != NSNotFound) {
        nameString  = [nameString substringToIndex:spaceRange.location];
    }
    return [nameString uppercaseString];
}



+ (NSString*)stringFromDate:(NSDate*)date {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)stringFromModifiedDate:(NSDate*)date {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)stringFromConditionDate:(NSString*)dateString {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate* tempDate    = [dateFormatter dateFromString:dateString];
    //[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:tempDate];
}

+ (NSDate*)dateFromString:(NSString*)dateString {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];    
    return [dateFormatter dateFromString:dateString];
}

+ (NSString*)stringFromModifiedString:(NSString*)dateString format:(NSString*)dateFormat {
    if (!dateString || [dateString isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSDate* tempDate    = [dateFormatter dateFromString:dateString];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    return [dateFormatter stringFromDate:tempDate];
}

+ (NSString*)modifiedStringFromDate:(NSDate*)date {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)stringFromDate:(NSDate*)date format:(NSString*)dateFormat {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)stringFromDateTime:(NSDate*)date {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)stringFromSyncDateTime:(NSDate*)date {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss A"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)stringFromRefreshSyncDateTime:(NSDate*)date {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss A"];
    [dateFormatter setDateFormat:@"dd MMM"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)UTCDateStringFromDate:(NSDate*)date {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate*)today {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
}

+ (NSDate*)defaultSyncDate {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MMM dd, yyyy, h:mm:ss a"];
    return [dateFormatter dateFromString:@"May 20, 1900, 3:18:40 PM"];
}

+ (NSString*)getSurveyReportDateString {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"MMddyy_hhmm"];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
     return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString*)todayString {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString*)getConditionDateStringFromString:(NSString*)dateString relative:(BOOL)relative {
    if (relative && [[self todayString] isEqualToString:dateString]) {
        return @"Today";
    }
    
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* tempDate    = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
    return [dateFormatter stringFromDate:tempDate];
}

+ (NSString*)getHistoryTieInDate:(NSString*)dateString {
    NSDateFormatter*    dateFormmater   = [[NSDateFormatter alloc] init];
    [dateFormmater setDateFormat:@"yyyy-MM-dd"];
    BOOL isItToday  = [[dateFormmater stringFromDate:[NSDate date]] isEqualToString:dateString];
    
    if (isItToday) {
        return @"Today";
    }else {
        NSDate* conditionDate   = [dateFormmater dateFromString:dateString];
        [dateFormmater setDateFormat:@"MMM d, yyyy"];
        return [dateFormmater stringFromDate:conditionDate];
    }
}


+ (NSInteger)integerFromString:(id)intObject {
    if (intObject && ![intObject isKindOfClass:[NSNull class]]) {
        return [(NSString*)intObject integerValue];
    }
    return 0;
}

+ (NSString*)stringFromString:(id)stringObject {
    if (stringObject && ![stringObject isKindOfClass:[NSNull class]]) {
        return (NSString*)stringObject;
    }
    return @"";
}

+ (NSString*)stringFromIntString:(id)stringObject {
    if (stringObject && ![stringObject isKindOfClass:[NSNull class]]) {
        return [NSString stringWithFormat:@"%d", [(NSString*)stringObject integerValue]];
    }
    return @"";
}

+ (double)doubleFromString:(id)intObject {
    if (intObject && ![intObject isKindOfClass:[NSNull class]]) {
        return [(NSString*)intObject doubleValue];
    }
    return 0.0;
}

+ (NSString*)stringFromPromoDate:(NSString*)dateString {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];

    NSDate* tempDate    = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    return [dateFormatter stringFromDate:tempDate];
}

+ (NSString*)stringFromPriorityDate:(NSString*)dateString {
    if ([dateString isEqual:[NSNull null]]) {
        return nil;
    }
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate* tempDate    = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    return [dateFormatter stringFromDate:tempDate];
}

+ (NSString*)stringFromPromoAttachmentDate:(NSString*)dateString {
    NSDateFormatter* dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    NSDate* tempDate    = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    return [dateFormatter stringFromDate:tempDate];
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

+ (NSString*)relativeStringFromRefreshSyncDateTime:(NSDate*)date {
    double time = [date timeIntervalSinceDate:[NSDate date]];
    time *= -1;
    if (time < 60) {
        int diff = round(time);
        if (diff == 1)
            return @"1 second ago";
        return [NSString stringWithFormat:@"%d seconds ago", diff];
    } else if (time < 3600) {
        int diff = round(time / 60);
        if (diff == 1)
            return @"1 minute ago";
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (time < 86400) {
        int diff = round(time / 60 / 60);
        if (diff == 1)
            return @"1 hour ago";
        return [NSString stringWithFormat:@"%d hours ago", diff];
    } else if (time < 604800) {
        int diff = round(time / 60 / 60 / 24);
        if (diff == 1)
            return @"yesterday";
        if (diff == 7)
            return @"a week ago";
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
//        int diff = round(time / 60 / 60 / 24 / 7);
//        if (diff == 1)
//            return @"a week ago";
//        return [NSString stringWithFormat:@"%d weeks ago", diff];
        NSDateFormatter *relativeDateFormatter = [[NSDateFormatter alloc] init];
        [relativeDateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [relativeDateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [relativeDateFormatter setDoesRelativeDateFormatting:YES];
        
        return [relativeDateFormatter stringForObjectValue:date];
    }
}

@end

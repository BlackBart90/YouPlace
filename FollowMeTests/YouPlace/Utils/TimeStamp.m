//
//  TimeStamp.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 12/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "TimeStamp.h"

@implementation TimeStamp
+ (NSString *)timeStampFromdDate:(NSDate *)date {
    
    int seconds =[date timeIntervalSince1970];
    NSString *strTimeStamp = [NSString stringWithFormat:@"%i",seconds];
    
    return strTimeStamp;
}
+(NSString *) GetUTCDateTimeFromLocalTime:(NSString *)IN_strLocalTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate  *objDate    = [dateFormatter dateFromString:IN_strLocalTime];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *strDateTime   = [dateFormatter stringFromDate:objDate];
    return strDateTime;
}

+ (NSTimeInterval) timeStampTimeIntervalFromDate:(NSDate *)date {
    return [date timeIntervalSince1970];
}
+ (NSDate *)dateFromTimeStamp:(NSString *)timeStamp
{
    double interval = [timeStamp floatValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}
@end

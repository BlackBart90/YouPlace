//
//  TimeStamp.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 12/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeStamp : NSObject
+ (NSString *)timeStampFromdDate:(NSDate *)date;
+ (NSTimeInterval) timeStampTimeIntervalFromDate:(NSDate *)date;
+ (NSDate *)dateFromTimeStamp:(NSString *)timeStamp;

@end

//
//  LocalNotificationManager.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 05/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "LocalNotificationManager.h"

@implementation LocalNotificationManager

+(void)localNotificationWithMessage:(NSString *)message
{
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    
    // if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)

            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate date];
            NSTimeZone* timezone = [NSTimeZone defaultTimeZone];
            notification.timeZone = timezone;
            notification.alertBody = message;
            notification.alertAction = @"Show";
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
@end

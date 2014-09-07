//
//  LocationsManager.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 05/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "LocationsManager.h"
#import "LocalNotificationManager.h"

@interface LocationsManager()

@property (nonatomic,assign) NSTimeInterval locationtime;
@property (nonatomic,assign) CLLocationDistance distance;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation LocationsManager

-(void)loadLocation:(CLLocation*)location
{
    // So doing it in separate thread with expiration handler to ensure it gets some time to do     the task even if the app goes to background.
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground || state == UIApplicationStateInactive){
        [self privateTasksWithLocation:location];
//
//       // NSLog(@"BACKGROUND");
//    UIApplication *application = [UIApplication sharedApplication];
//    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//
//        [application endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        bgTask = UIBackgroundTaskInvalid;
//
//        [application endBackgroundTask:bgTask];
//        
//    });
    }else
    {
      //  NSLog(@"ACTIVE");
        [self privateTasksWithLocation:location];
    }
}

-(void)addTime
{
    if (self.locationtime == 1200) { // 20 minuti
        [LocalNotificationManager localNotificationWithMessage:@"posto salvato"];
        
        // salvo i dati !!
 
        self.locationtime = 0;
        [self.timer invalidate];
        self.timer = nil;
    }
    NSLog(@"timer %f",self.locationtime);
    self.locationtime += 1;

}
-(void)privateTasksWithLocation:(CLLocation *)location
{
    [self checkUserMovement:location];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
 
//  self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
    self.timer=  [NSTimer timerWithTimeInterval:1
                            target:self
                          selector:@selector(addTime)
                          userInfo:nil
                           repeats:YES];

    [[NSRunLoop mainRunLoop] addTimer:self.timer
                              forMode:NSRunLoopCommonModes];
}

-(NSTimeInterval)getLocationtime
{
    return self.locationtime;
}
-(float)getDistance
{
    return self.distance;
}
#pragma mark - locations movements -
-(void)fixMainLocation:(CLLocation *)mainloc
{
    self.mainLocation = mainloc;
}
-(void)checkUserMovement:(CLLocation *)location
{
    if (self.mainLocation) {

    CLLocationDistance tmpDistance = [location distanceFromLocation:self.mainLocation];
    self.distance = tmpDistance;
        NSLog(@"main locations: %@   location :%@    distance %f",self.mainLocation,location,tmpDistance);
        if (tmpDistance > 30) {
            self.mainLocation = location;
        }
    }
}


@end

//
//  main.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 25/07/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));

        }
        @catch (NSException *exception) {
            NSLog(@"main exception : %@",exception);
        }
       
    }
}

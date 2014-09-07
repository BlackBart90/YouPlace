//
//  Account.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 03/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "AccountParse.h"


static AccountParse *sharedClassInstance = nil;

@implementation AccountParse


+ (AccountParse*) sharedClass {
    @synchronized(self) {
        if (!sharedClassInstance)
            sharedClassInstance = [[AccountParse alloc] init];
        return sharedClassInstance;
    }
}
-(BOOL)userLoggedIn
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        return YES;
    } else {
        return NO;
    }
}
-(void)login
{
    NSArray *permissions = [NSArray arrayWithObjects:@"user_photos",@"user_about_me",@"user_videos",@"user_birthday",@"publish_stream",@"offline_access",@"user_checkins",@"friends_checkins",@"email",@"user_location" ,nil];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            //
            //            // adding gameScore of user
            PFObject *testObject = [PFObject objectWithClassName:@"DataUser"];
            [testObject setObject:user forKey:@"user"];
            [testObject saveInBackground];
            
            FBRequest *request = [FBRequest requestForMe];
            // Send request to Facebook
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                
                if (!error) {
                    
                    // result is a dictionary with the user's Facebook data
                    NSDictionary *userData = (NSDictionary *)result;
                    [self saveUserWithData:userData];
                    [self.delegate userDidLoggedIn];
                }
                else
                {
                    NSLog(@"ERROR :%@",error);
                }
            }];
            
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            [self.delegate userDidLoggedIn];

            NSLog(@"User logged in through Facebook!");
        }
    }];
}
- (void)saveUserWithData:(NSDictionary *)result
{
    
    PFUser *user = [PFUser currentUser];
    user.username = [NSString stringWithFormat:@"%@ %@",result[@"last_name"],result[@"first_name"]];
    user[@"email"] = result[@"email"];
    user[@"gender"] = result[@"gender"];
    user[@"facebook_id"] = result[@"id"];
    user[@"city"] = result[@"location"][@"name"];
    user[@"birthday"] = result[@"birthday"];
    user[@"visible"] = @YES;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            NSLog(@"error : %@",[error description]);
        }
    }];
    
    
}
@end

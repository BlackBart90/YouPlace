//
//  Account.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 03/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol MyParseAccountProtocol <NSObject>

-(void)userDidLoggedIn;

@end
@interface AccountParse: NSObject
+ (AccountParse*) sharedClass;
-(void)login;
-(BOOL)userLoggedIn;


@property (nonatomic,weak) id <MyParseAccountProtocol> delegate;

@end

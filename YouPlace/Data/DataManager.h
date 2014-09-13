//
//  DataManager.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 07/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseData.h"
#import "dbManager.h"

#import "Note.h"


@interface DataManager : NSObject
+(void)initializeDataManagementWithOptions:(NSDictionary *)options;
+(id)retriveDataFromDBTable:(NSString *)tableName;
+(void)sincMoments;


+(void)saveNote:(Note *)newNote inPlace:(Place *)place completionDBBlock:(void(^)(void))completionDB remoteCompletionBlock:(void(^)(void))remoteCompletion remoteFailureBlock:(void(^)(void))remoteFailure;
+(void)saveImage:(NSData *)imageData inPlace:(Place *)place withData:(NSDictionary *)data completionDBBlock:(void(^)(Moment *finalMom))completionDB remoteCompletionBlock:(void(^)(Moment *finalMom))remoteCompletion remoteFailureBlock:(void(^)(void))remoteFailure;


+(void)loadFastDBImages:(void(^)(NSArray *images))imagesBlock fromContainerName:(NSString *)containerName;

@end

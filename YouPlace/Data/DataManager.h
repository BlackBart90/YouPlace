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


+(void)saveNote:(Note *)newNote;
+(void)saveImage:(NSData *)imageData;

@end

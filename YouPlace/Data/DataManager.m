//
//  DataManager.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 07/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "DataManager.h"


@implementation DataManager

+(void)initializeDataManagement
{
    [dbManager checkAndCreateDatabase];
}

+(void)saveNote:(Note *)newNote
{
    
    
    
    [dbManager addNoteInDB:newNote];
}
+(id)retriveDataFromDBTable:(NSString *)tableName
{
  return   [dbManager elementsFromTableName:tableName];
}
@end

//
//  DataManager.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 07/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "DataManager.h"


@implementation DataManager

+(void)initializeDataManagementWithOptions:(NSDictionary *)options
{
    // PARSE
    [Parse setApplicationId:@"cJDOYQQLWxG7LpLal0HXloB30YEKVTv1ek2AwM8o" clientKey:@"kAIDv7HgWyqfkUCgcRDxgNNLBaMYZWV1ovJcWAM9"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:options];
    [PFFacebookUtils initializeFacebook];
    
    // DB
    [dbManager checkAndCreateDatabase];
    
}


#pragma mark - private methods -
+(void)saveNewMoment:(Moment *)moment inPlace:(Place *)place
        successParse:(void(^)(void))successParseBlock successDB:(void(^)(Moment *finalDBMoment))successDBBlock
        failureParse:(void(^)(void))failureParseBlock failureDB:(void(^)(void))failureDBBlock
{
 
    [dbManager addMomentInDB:moment];
    successDBBlock(moment);
    

    //PARSE
    [ParseData saveNewMoment:moment inNewPlace:place success:^{
        
        successParseBlock();
        
    } failure:^{
        failureParseBlock();
        NSLog(@"moment non salvato");
    }];
}



// TESTS
+(void)saveImage:(NSData *)imageData
{
    [dbManager saveImage:imageData];
}
+(void)saveNote:(Note *)newNote
{
    [dbManager addNoteInDB:newNote];
}
+(id)retriveDataFromDBTable:(NSString *)tableName
{
  return  [dbManager elementsFromTableName:tableName];
}


@end

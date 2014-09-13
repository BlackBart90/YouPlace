//
//  DataManager.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 07/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "DataManager.h"
#import "Utils.h"

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
 
    NSAssert([moment validateMoment], @"moment not valid");
    NSAssert([place validatePlace], @"place not valid");
    
    [dbManager addMomentInDB:moment];
    successDBBlock(moment);
    
    // failure block for db manager not presented yet..

    //PARSE
    [ParseData saveNewMoment:moment inNewPlace:place success:^{
        
        successParseBlock();
        
    } failure:^{
        failureParseBlock();
        NSLog(@"moment non salvato");
    }];
}

#pragma mark - public methods -
+(void)saveImage:(NSData *)imageData inPlace:(Place *)place withData:(NSDictionary *)data
                        completionDBBlock:(void(^)(Moment *finalMom))completionDB
                        remoteCompletionBlock:(void(^)(Moment *finalMom))remoteCompletion
                        remoteFailureBlock:(void(^)(void))remoteFailure
{
    NSAssert([place validatePlace], @"place is not valid");
    NSAssert(imageData, @"there is not image");
    
    Moment *mom = [Moment newMomentwithPlace:place withData:data];
    NSAssert([mom validateMoment], @"moment is not complete");
    
    
    [self saveNewMoment:mom inPlace:mom.place successParse:^{
        
        remoteCompletion(mom);
    } successDB:^(Moment *finalDBMoment) {
        
        [dbManager saveImage:imageData withMomentId:finalDBMoment.uniqueid andUniqueid:[Utils createUUID]];
        completionDB(finalDBMoment);

    } failureParse:^{
        remoteFailure();
    } failureDB:^{}];

}
+(void)saveNote:(Note *)newNote inPlace:(Place *)place
                            completionDBBlock:(void(^)(void))completionDB
                            remoteCompletionBlock:(void(^)(void))remoteCompletion
                            remoteFailureBlock:(void(^)(void))remoteFailure
{
    NSAssert([place validatePlace], @"place is not valid");
    NSAssert(!newNote.momentID, @"the note has already a valid uniqueid");
    
    NSDictionary * dictData = @{kMomentNameKEY:kDefaultMomentName,
                                kMomentContainerNameKEY:newNote.containerName,
                                kMomentNoteContentKEY:newNote.content,
                                };
    
    Moment *mom = [Moment newMomentwithPlace:place withData:dictData];
    NSAssert([mom validateMoment], @"moment is not complete");

    [self saveNewMoment:mom inPlace:mom.place successParse:^{
        
        remoteCompletion();
        
    } successDB:^(Moment *finalDBMoment) {
        
        newNote.momentID = finalDBMoment.uniqueid;
        newNote.uniqueID = [Utils createUUID];
        [dbManager addNoteInDB:newNote];
        completionDB();
        
    } failureParse:^{
        remoteFailure();
    } failureDB:^{}];
}
+(id)retriveDataFromDBTable:(NSString *)tableName
{
  return [dbManager elementsFromTableName:tableName];
}




@end

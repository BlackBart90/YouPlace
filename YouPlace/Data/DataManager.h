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

@class MainViewController;

@interface DataManager : NSObject
+(void)initializeDataManagementWithOptions:(NSDictionary *)options inMainController:(MainViewController *)mainController;
+(id)retriveDataFromDBTable:(NSString *)tableName;
+(void)sincMomentsCompletion:(void(^)(void))completionBlock;
+(void)sincPlacesCompletion:(void(^)(void))completionBlock;

+(void)saveNote:(Note *)newNote inPlace:(Place *)place completionDBBlock:(void(^)(void))completionDB remoteCompletionBlock:(void(^)(void))remoteCompletion remoteFailureBlock:(void(^)(void))remoteFailure;

+(void)saveImage:(NSData *)imageData inPlace:(Place *)place withData:(NSDictionary *)data imageUUID:(NSString *)uuid completionDBBlock:(void(^)(Moment *finalMom))completionDB remoteCompletionBlock:(void(^)(Moment *finalMom))remoteCompletion remoteFailureBlock:(void(^)(void))remoteFailure;

+(void)saveContact:(Contact *)contact inPlace:(Place *)place completionDBBlock:(void(^)(void))completionDB remoteCompletionBlock:(void(^)(void))remoteCompletion remoteFailureBlock:(void(^)(void))remoteFailure;

+(void)loadFastDBImages:(void(^)(NSArray *images))imagesBlock fromContainerName:(NSString *)containerName;
+(void)loadNotes:(void(^)(NSArray *notes))notesBlock fromContainerName:(NSString *)containerName;
+(void)loadPlaces:(void(^)(NSArray *places))placesBlock fromContainerName:(NSString *)containerName;
+(void)loadMoments:(void(^)(NSArray *moments))momentsBlock fromContainerName:(NSString *)containerName;
+(void)loadContacts:(void(^)(NSArray *contacts))contactsBlock fromContainerName:(NSString *)containerName;

@end

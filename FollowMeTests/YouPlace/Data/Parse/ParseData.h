//
//  ParseData.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 11/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "Place.h"
#import "Moment.h"

@import CoreLocation;

@interface ParseData : NSObject
+(void)sendPlaceToServer:(Place *)place success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock;
+(void)getPlacesFromServerSuccess:(void(^)(NSArray *places))successBlock failure:(void(^)(void))failureBlock;
+(void)removePlaceFromServer:(Place *)place success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock;



+(void)saveMomentInHistory:(Moment *)moment success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock;
+(void)getMomentsFromServerSuccess:(void(^)(NSArray *moments))successBlock failure:(void(^)(void))failureBlock;



+(void)saveNewMoment:(Moment *)newMoment inNewPlace:(Place *)newPlace success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock;

+(void)getPlaceFromId:(NSString *)uniqueid success:(void(^)(Place *place))successBlock failure:(void(^)(void))failureBlock;


+(void)uploadImageWithData:(NSData *)imageData andMoment:(Moment *)moment success:(void(^)(void))successBlock error:(void(^)(void))errorBlock;


+(void)loadImageWithPlaceId:(NSString *)placeId success:(void(^)(NSArray *arrayFile))success error:(void(^)(void))errorBlock;
+(void)loadImageWithMomentId:(NSString *)momentID success:(void(^)(NSArray *arrayFile))success error:(void(^)(void))errorBlock;
+(void)loadImageWithContainerName:(NSString *)containerName success:(void(^)(NSArray *arrayFile))success error:(void(^)(void))errorBlock;

@end

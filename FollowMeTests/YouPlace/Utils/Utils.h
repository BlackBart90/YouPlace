//
//  Utils.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 11/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import "Moment.h"


@interface Utils : NSObject

+(Place *)placeFromDictionary:(NSDictionary *)dictPlace;
+(NSDictionary *)dictionaryFromPlace:(Place *)place;


+(Moment *)momentFromDictionary:(NSDictionary *)dictMoment andPlacesArray:(NSArray *)places;
+(NSDictionary *)dictionaryFromMoment:(Moment *)moment;



+(NSString *)stringJSONFromDictionary:(NSDictionary *)dictionary;
+(NSDictionary*)dictionaryFromStringJSON:(NSString *)stringJSON error:(NSError *)error;
+(NSString *)createUUID;

@end

//
//  Utils.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 11/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "Utils.h"
#import "TimeStamp.h"
#import "ParseData.h"

@import CoreLocation;

@implementation Utils
#pragma mark - PLACES -
+(Place *)placeFromDictionary:(NSDictionary *)dictPlace 
{
    Place *newPlace = [Place new];
    newPlace.lat = [dictPlace objectForKey:@"lat"];
    newPlace.lng = [dictPlace objectForKey:@"lng"];
    newPlace.name = [dictPlace objectForKey:@"name"];
    newPlace.uniqueid = [dictPlace objectForKey:@"id"];
    int radius = (int)[[dictPlace objectForKey:@"region_radius"] integerValue];
    newPlace.regionRadius = radius;
    
    return newPlace;
}

+(NSDictionary *)dictionaryFromPlace:(Place *)place
{
    
    return @{@"name":place.name,
             @"id":place.uniqueid,
             @"lat":place.lat,
             @"lng":place.lng,
             @"region_radius":[NSString stringWithFormat:@"%i",place.regionRadius]};
}
#pragma mark - MOMENTS -
+(Moment *)momentFromDictionary:(NSDictionary *)dictMoment andPlacesArray:(NSArray *)places
{
    Moment *newMoment = [Moment new];
    newMoment.startDate = [TimeStamp dateFromTimeStamp:[dictMoment objectForKey:@"start_date"]];
    newMoment.endDate = [TimeStamp dateFromTimeStamp:[dictMoment objectForKey:@"end_date"]];
    newMoment.containerName = [dictMoment objectForKey:@"name_container"];
    newMoment.uniqueid = [dictMoment objectForKey:@"id"];
    BOOL check = FALSE;
    for (Place *singlePlace in places) {
        if ([singlePlace.uniqueid isEqualToString:[dictMoment objectForKey:@"id_place"]]) {
            newMoment.place = singlePlace;
            check = TRUE;
            break;
        }
    }
    
    if (!check) {
        NSLog(@"non esiste il posto");
    }
    newMoment.name = [dictMoment objectForKey:@"name"];
    newMoment.info = [self dictionaryFromStringJSON:[dictMoment objectForKey:@"info"] error:nil];
    return newMoment;
}
+(NSDictionary *)dictionaryFromMoment:(Moment *)moment
{
    
    return @{@"id_place":moment.place.uniqueid,
             @"start_date":[TimeStamp timeStampFromdDate:moment.startDate],
             @"end_date":[TimeStamp timeStampFromdDate:moment.endDate],
             @"info":[Utils stringJSONFromDictionary:moment.info],
             @"id":moment.uniqueid,
             @"name_container":moment.containerName,
             @"name":moment.name};
}
+(NSString *)stringJSONFromDictionary:(NSDictionary *)dictionary
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = @"";
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
+(NSDictionary*)dictionaryFromStringJSON:(NSString *)stringJSON error:(NSError *)error
{
    NSData *data = [stringJSON dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
    return jsonResponse;
}

+ (NSArray *)reversedArrayFromArray:(NSArray *)originalArray{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[originalArray count]];
    NSEnumerator *enumerator = [originalArray reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}
+(NSString *)createUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}
@end

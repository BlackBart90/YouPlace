//
//  ParseData.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 11/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "ParseData.h"
#import "Utils.h"
#import "Place.h"
#import "MomentContainerFactory.h"

@implementation ParseData



#pragma mark - public methods -

#pragma mark - PLACES -
+(void)sendPlaceToServer:(Place *)place success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock
{

    if (!place || !place.name || !place.uniqueid || !place.lat || !place.lng) {
        return;
    }
    
    NSDictionary *dictData  = [NSDictionary new];
        PFUser *currentUser = [PFUser currentUser];
    
        if (currentUser) {
            
            dictData = [Utils dictionaryFromPlace:place];
            
            PFQuery *query = [PFQuery queryWithClassName:@"DataUser"];
            [query whereKey:@"user" equalTo:[PFUser currentUser]];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (objects.count > 0){
                    PFObject *obj  = [objects objectAtIndex:0];

                    if ([[obj objectForKey:@"places"] isKindOfClass:[NSArray class]]) {
                        NSArray* places = [obj objectForKey:@"places"];
                        NSMutableArray *mutPlaces = [[NSMutableArray alloc]initWithArray:places];
                        
                        BOOL check = false;
                        for (int i = 0 ; i < mutPlaces.count ; i++){
                            NSDictionary *dictPlace;
                           // NSString*jsonString = [mutPlaces objectAtIndex:i];
                          //  NSDictionary *dictPlace = [Utils dictionaryFromStringJSON:jsonString error:nil];
                            if ([[places objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                dictPlace = [places objectAtIndex:i];
                            }
                            if ([[places objectAtIndex:i] isKindOfClass:[NSString class]]) {
                                 NSString*jsonString = [mutPlaces objectAtIndex:i];
                                dictPlace = [Utils dictionaryFromStringJSON:jsonString error:nil];
                            }
                            if (dictPlace && [[dictPlace objectForKey:@"id"] isEqualToString:place.uniqueid]) {
                                [mutPlaces replaceObjectAtIndex:i withObject:[Utils stringJSONFromDictionary:dictData]];
                                check = true;
                                break;
                            }
                        }
                        if (!check) {
                            [mutPlaces addObject:[Utils stringJSONFromDictionary:dictData]];
                        }
                        
                        [obj setObject:(NSArray *)mutPlaces forKey:@"places"];
                    }
             
                    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            successBlock();
                        }else
                            failureBlock();
                    }];
                    
                }else
                {
                    UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:@"Errore di connessione"
                                                                       message:@"dati non salvati nel server"
                                                                      delegate:nil
                                                             cancelButtonTitle:@"ok"
                                                             otherButtonTitles:nil, nil];
                    [myAlert show];
                }
            }];
            
        }

}
+(void)removePlaceFromServer:(Place *)place success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock
{
    if (!place || !place.name || !place.uniqueid || !place.lat || !place.lng) {
        return;
    }
    
    NSDictionary *dictData  = [NSDictionary new];
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        
        dictData = [Utils dictionaryFromPlace:place];
        
        PFQuery *query = [PFQuery queryWithClassName:@"DataUser"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (objects.count > 0){
                PFObject *obj  = [objects objectAtIndex:0];
                
                if ([[obj objectForKey:@"places"] isKindOfClass:[NSArray class]]) {
                    NSArray* places = [obj objectForKey:@"places"];
                    NSMutableArray *mutPlaces = [[NSMutableArray alloc]initWithArray:places];
                    
                    BOOL check = false;
                    for (int i = 0 ; i < mutPlaces.count ; i++){
                        NSDictionary *dictPlace;
                        // NSString*jsonString = [mutPlaces objectAtIndex:i];
                        //  NSDictionary *dictPlace = [Utils dictionaryFromStringJSON:jsonString error:nil];
                        if ([[places objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            dictPlace = [places objectAtIndex:i];
                        }
                        if ([[places objectAtIndex:i] isKindOfClass:[NSString class]]) {
                            NSString*jsonString = [mutPlaces objectAtIndex:i];
                            dictPlace = [Utils dictionaryFromStringJSON:jsonString error:nil];
                        }
                        
                        if (dictPlace && [[dictPlace objectForKey:@"id"] isEqualToString:place.uniqueid]) {
                            [mutPlaces removeObjectAtIndex:i];
                            check = true;
                            break;
                        }
                    }
                    /// moments
                    
                    [self findAllMomentsWithPlaceId:place.uniqueid success:^(NSArray *momentsWithPlace) {
                        for (Moment *singleMoment in momentsWithPlace) {
                            [self removeMomentFromServer:singleMoment success:^{
                                NSLog(@"momento con place id rimosso");
                            } failure:^{
                                
                            }];
                        }
                    }];
                    
                    ///
                    
                    [obj setObject:(NSArray *)mutPlaces forKey:@"places"];
                }
                
                [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        successBlock();
                    }else
                        failureBlock();
                }];
                
            }else
            {
                UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:@"Errore di connessione"
                                                                   message:@"dati non salvati nel server"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"ok"
                                                         otherButtonTitles:nil, nil];
                [myAlert show];
            }
        }];
        
    }
    

}
+(void)getPlacesFromServerSuccess:(void(^)(NSArray *places))successBlock failure:(void(^)(void))failureBlock
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"DataUser"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (objects.count > 0){
                PFObject *obj  = [objects objectAtIndex:0];
                
                if ([[obj objectForKey:@"places"] isKindOfClass:[NSArray class]]) {
                    NSArray* places = [obj objectForKey:@"places"];
                    
                    NSMutableArray *mutPlaces = [[NSMutableArray alloc]init];
                    
                    for (int i = 0 ; i < places.count ; i++){
                        NSString*jsonString = [places objectAtIndex:i];
                        NSDictionary *dictPlace = [Utils dictionaryFromStringJSON:jsonString error:nil];
                        Place *singlePlace = [Utils placeFromDictionary:dictPlace];
                        
                        [mutPlaces addObject:singlePlace];
                       /* if ([[places objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *dictPlace = [places objectAtIndex:i];
                            Place *singlePlace = [Utils placeFromDictionary:dictPlace];
                            
                            [mutPlaces addObject:singlePlace];
                        }*/

                    }
    
                    successBlock((NSArray *)mutPlaces);
                }
                
             
            }else
            {
                failureBlock();
                UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:@"Errore di connessione"
                                                                   message:@"dati non salvati nel server"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"ok"
                                                         otherButtonTitles:nil, nil];
                [myAlert show];
            }
        }];
        
    }

}

#pragma mark - HISTORY -
+(void)saveMomentInHistory:(Moment *)moment success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock
{
    
    if (!moment || !moment.name || !moment.uniqueid || !moment.place || !moment.startDate || !moment.endDate || !moment.info || !moment.place.uniqueid || !moment.containerName) {
        return;
    }
    
    NSDictionary *dictData  = [NSDictionary new];
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        
        dictData = [Utils dictionaryFromMoment:moment];
        
        PFQuery *query = [PFQuery queryWithClassName:@"DataUser"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (objects.count > 0){
                PFObject *obj  = [objects objectAtIndex:0];
                
                if ([[obj objectForKey:@"history"] isKindOfClass:[NSArray class]]) {
                    NSArray* historyMoments = [obj objectForKey:@"history"];
                    NSMutableArray *mutMoments = [[NSMutableArray alloc]initWithArray:historyMoments];
                    
                    BOOL check = false;
                    for (int i = 0 ; i < historyMoments.count ; i++){
                        NSDictionary *dictMoment;
                        // NSString*jsonString = [mutPlaces objectAtIndex:i];
                        //  NSDictionary *dictPlace = [Utils dictionaryFromStringJSON:jsonString error:nil];
                        if ([[historyMoments objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            dictMoment = [historyMoments objectAtIndex:i];
                        }
                        if ([[historyMoments objectAtIndex:i] isKindOfClass:[NSString class]]) {
                            NSString*jsonString = [historyMoments objectAtIndex:i];
                            dictMoment = [Utils dictionaryFromStringJSON:jsonString error:nil];
                        }
                        if (dictMoment && [[dictMoment objectForKey:@"id"] isEqualToString:moment.uniqueid]) {
                            [mutMoments replaceObjectAtIndex:i withObject:[Utils stringJSONFromDictionary:dictData]];
                            check = true;
                            break;
                        }
                    }
                    if (!check) {
                        [mutMoments addObject:[Utils stringJSONFromDictionary:dictData]];
                    }
                    
                    [obj setObject:(NSArray *)mutMoments forKey:@"history"];
                }
                
                
                
                
                
                [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        successBlock();
                    }else
                        failureBlock();
                }];
                
            }else
            {
                UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:@"Errore di connessione"
                                                                   message:@"dati non salvati nel server"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"ok"
                                                         otherButtonTitles:nil, nil];
                [myAlert show];
            }
        }];
        
    }
}
+(void)getMomentsFromServerSuccess:(void(^)(NSArray *moments))successBlock failure:(void(^)(void))failureBlock
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"DataUser"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (objects.count > 0){
                PFObject *obj  = [objects objectAtIndex:0];
                
                if ([[obj objectForKey:@"history"] isKindOfClass:[NSArray class]]) {
                    NSArray* moments = [obj objectForKey:@"history"];
                    
                    NSMutableArray *mutMoments = [[NSMutableArray alloc]init];
                    [ParseData getPlacesFromServerSuccess:^(NSArray *places) {
                        
                        for (int i = 0 ; i < moments.count ; i++){
                            NSString*jsonString = [moments objectAtIndex:i];
                            NSDictionary *dictMoment = [Utils dictionaryFromStringJSON:jsonString error:nil];
                            
                            
                            Moment *singleMoment = [Utils momentFromDictionary:dictMoment andPlacesArray:places];
                            [mutMoments addObject:singleMoment];
                            /* if ([[places objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                             NSDictionary *dictPlace = [places objectAtIndex:i];
                             Place *singlePlace = [Utils placeFromDictionary:dictPlace];
                             
                             [mutPlaces addObject:singlePlace];
                             }*/
                            
                        }
                        
                        successBlock((NSArray *)mutMoments);
                    } failure:^{
                        
                    }];
                    
                }
                
                
            }else
            {
                failureBlock();
                UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:@"Errore di connessione"
                                                                   message:@"dati non salvati nel server"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"ok"
                                                         otherButtonTitles:nil, nil];
                [myAlert show];
            }
        }];
        
    }
    
}
+(void)removeMomentFromServer:(Moment *)moment success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock
{
    if (!moment || !moment.name || !moment.uniqueid || !moment.place || !moment.startDate || !moment.endDate || !moment.info || !moment.place.uniqueid) {
        return;
    }
    
    NSDictionary *dictData  = [NSDictionary new];
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        
        dictData = [Utils dictionaryFromMoment:moment];
        
        PFQuery *query = [PFQuery queryWithClassName:@"DataUser"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (objects.count > 0){
                PFObject *obj  = [objects objectAtIndex:0];
                
                if ([[obj objectForKey:@"history"] isKindOfClass:[NSArray class]]) {
                    NSArray* moments = [obj objectForKey:@"history"];
                    NSMutableArray *mutMoments = [[NSMutableArray alloc]initWithArray:moments];
                    
                    BOOL check = false;
                    for (int i = 0 ; i < moments.count ; i++){
                        NSDictionary *dictMoment;
                        // NSString*jsonString = [mutPlaces objectAtIndex:i];
                        //  NSDictionary *dictPlace = [Utils dictionaryFromStringJSON:jsonString error:nil];
                        if ([[moments objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            dictMoment = [moments objectAtIndex:i];
                        }
                        if ([[moments objectAtIndex:i] isKindOfClass:[NSString class]]) {
                            NSString*jsonString = [moments objectAtIndex:i];
                            dictMoment = [Utils dictionaryFromStringJSON:jsonString error:nil];
                        }
                        
                        if (dictMoment && [[dictMoment objectForKey:@"id"] isEqualToString:moment.uniqueid]) {
                            [mutMoments removeObjectAtIndex:i];
                            check = true;
                            break;
                        }
                    }
                    
                    [obj setObject:(NSArray *)mutMoments forKey:@"history"];
                }
                
                [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        successBlock();
                    }else
                        failureBlock();
                }];
                
            }else
            {
                UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:@"Errore di connessione"
                                                                   message:@"dati non salvati nel server"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"ok"
                                                         otherButtonTitles:nil, nil];
                [myAlert show];
            }
        }];
        
    }

}


#pragma mark - Combine methods - tmp -
+(void)findAllMomentsWithPlaceId:(NSString *)placeId success:(void(^)(NSArray *momentsWithPlace))successBlock
{
    [self getMomentsFromServerSuccess:^(NSArray *moments) {
        
        NSMutableArray *mutArrayMoments = [[NSMutableArray alloc]init];
        for (Moment *mom in moments) {
            if ([mom.place.uniqueid isEqualToString:placeId]) {
                [mutArrayMoments addObject:mom];
            }
        }
        successBlock((NSArray *)mutArrayMoments);
    } failure:^{
        
    }];
}
+(void)saveNewMoment:(Moment *)newMoment inNewPlace:(Place *)newPlace success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock
{
    if (!newMoment || !newMoment.name || !newMoment.uniqueid || !newMoment.place || !newMoment.startDate || !newMoment.endDate || !newMoment.info || !newMoment.place.uniqueid) {
        NSLog(@"moment is not valid");
        return;
    }
    
    if (!newPlace || !newPlace.name || !newPlace.uniqueid || !newPlace.lat || !newPlace.lng) {
        NSLog(@"place is not valid");

        return;
    }
    NSDictionary *dictDataMoment  = [NSDictionary new];
    NSDictionary *dictDataPlace  = [NSDictionary new];

    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        
        dictDataMoment = [Utils dictionaryFromMoment:newMoment];
        dictDataPlace = [Utils dictionaryFromPlace:newPlace];
        
        PFQuery *query = [PFQuery queryWithClassName:@"DataUser"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0){
                PFObject *obj  = [objects objectAtIndex:0];
                
                //PLACE
                if ([[obj objectForKey:@"places"] isKindOfClass:[NSArray class]]) {
                    NSArray* places = [obj objectForKey:@"places"];
                    NSMutableArray *mutPlaces = [[NSMutableArray alloc]initWithArray:places];
                    
                    BOOL check = false;
                    for (int i = 0 ; i < mutPlaces.count ; i++){
                        NSDictionary *dictPlace;
                        // NSString*jsonString = [mutPlaces objectAtIndex:i];
                        //  NSDictionary *dictPlace = [Utils dictionaryFromStringJSON:jsonString error:nil];
                        if ([[places objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            dictPlace = [places objectAtIndex:i];
                        }
                        if ([[places objectAtIndex:i] isKindOfClass:[NSString class]]) {
                            NSString*jsonString = [mutPlaces objectAtIndex:i];
                            dictPlace = [Utils dictionaryFromStringJSON:jsonString error:nil];
                        }
                        if (dictPlace && [[dictPlace objectForKey:@"id"] isEqualToString:newPlace.uniqueid]) {
                            [mutPlaces replaceObjectAtIndex:i withObject:[Utils stringJSONFromDictionary:dictDataPlace]];
                            check = true;
                            break;
                        }
                    }
                    if (!check) {
                        [mutPlaces addObject:[Utils stringJSONFromDictionary:dictDataPlace]];
                    }
                    
                    [obj setObject:(NSArray *)mutPlaces forKey:@"places"];
                }

                //MOMENT
                if ([[obj objectForKey:@"history"] isKindOfClass:[NSArray class]]) {
                    NSArray* historyMoments = [obj objectForKey:@"history"];
                    NSMutableArray *mutMoments = [[NSMutableArray alloc]initWithArray:historyMoments];
                    
                    BOOL check = false;
                    for (int i = 0 ; i < historyMoments.count ; i++){
                        NSDictionary *dictMoment;
                        // NSString*jsonString = [mutPlaces objectAtIndex:i];
                        //  NSDictionary *dictPlace = [Utils dictionaryFromStringJSON:jsonString error:nil];
                        if ([[historyMoments objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            dictMoment = [historyMoments objectAtIndex:i];
                        }
                        if ([[historyMoments objectAtIndex:i] isKindOfClass:[NSString class]]) {
                            NSString*jsonString = [historyMoments objectAtIndex:i];
                            dictMoment = [Utils dictionaryFromStringJSON:jsonString error:nil];
                        }
                        if (dictMoment && [[dictMoment objectForKey:@"id"] isEqualToString:newMoment.uniqueid]) {
                            [mutMoments replaceObjectAtIndex:i withObject:[Utils stringJSONFromDictionary:dictDataMoment]];
                            check = true;
                            break;
                        }
                    }
                    if (!check) {
                        [mutMoments addObject:[Utils stringJSONFromDictionary:dictDataMoment]];
                    }
                    
                    [obj setObject:(NSArray *)mutMoments forKey:@"history"];
                }
         
                
                [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        successBlock();
                    }else
                        failureBlock();
                }];
                
            }else
            {
                UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:@"Errore di connessione"
                                                                   message:@"dati non salvati nel server"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"ok"
                                                         otherButtonTitles:nil, nil];
                [myAlert show];
            }
        }];
        
    }
    
}
#pragma mark - utils -
+(void)getPlaceFromId:(NSString *)uniqueid success:(void(^)(Place *place))successBlock failure:(void(^)(void))failureBlock
{
    [self getPlacesFromServerSuccess:^(NSArray *places) {
        for (Place *singlePlace in places) {
            if ([singlePlace.uniqueid isEqualToString:uniqueid]) {
                successBlock(singlePlace);
                break;
            }
        }
    } failure:^{
        failureBlock();
    }];
}

#pragma mark - photos -
+(void)uploadImageWithData:(NSData *)imageData andMoment:(Moment *)moment success:(void(^)(void))successBlock error:(void(^)(void))errorBlock;
{
    if (moment.uniqueid.length) {

    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    //HUD creation here (see example for code)
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            [userPhoto setObject:moment.uniqueid forKey:@"momentId"];
            [userPhoto setObject:moment.place.uniqueid forKey:@"placeId"];
            [userPhoto setObject:moment.containerName forKey:@"containerName"];
            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [userPhoto.ACL setReadAccess:YES forUser:[PFUser currentUser]];
            PFUser *user = [PFUser currentUser];
            
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"photo saved");
                    successBlock();
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                    errorBlock();
                    
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
    }];
        
    }else
    {
        NSLog(@"il momento non ha uniqueid");
    }
}
+(void)loadImageWithPlaceId:(NSString *)placeId success:(void(^)(NSArray *arrayFile))success error:(void(^)(void))errorBlock
{
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser && placeId) {
        NSMutableArray *mutArrayFiles = [[NSMutableArray alloc]init];
        PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKey:@"placeId" containsString:placeId];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (objects.count > 0){
                
                for (PFObject *obj in objects) {
                    PFFile *fileDataImage = (PFFile *)[obj objectForKey:@"imageFile"];
                    [mutArrayFiles addObject:fileDataImage];

                }
                success((NSArray *)mutArrayFiles);
            }
        }];
        
    }
}
+(void)loadImageWithMomentId:(NSString *)momentID success:(void(^)(NSArray *arrayFile))success error:(void(^)(void))errorBlock
{
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser && momentID) {
        NSMutableArray *mutArrayFiles = [[NSMutableArray alloc]init];
        PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKey:@"momentId" containsString:momentID];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (objects.count > 0){
                
                for (PFObject *obj in objects) {
                    PFFile *fileDataImage = (PFFile *)[obj objectForKey:@"imageFile"];
                    [mutArrayFiles addObject:fileDataImage];
                    
                }
                success((NSArray *)mutArrayFiles);
            }
        }];
        
    }
}
+(void)loadImageWithContainerName:(NSString *)containerName success:(void(^)(NSArray *arrayFile))success error:(void(^)(void))errorBlock
{
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser && containerName) {
        NSMutableArray *mutArrayFiles = [[NSMutableArray alloc]init];
        PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKey:@"containerName" containsString:containerName];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (objects.count > 0){
                
                for (PFObject *obj in objects) {
                    PFFile *fileDataImage = (PFFile *)[obj objectForKey:@"imageFile"];
                    [mutArrayFiles addObject:fileDataImage];
                    
                }
                success((NSArray *)mutArrayFiles);
            }
        }];
        
    }
}
@end

//
//  DataManager.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 07/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "DataManager.h"
#import "Utils.h"
#import "Contact.h"
#import "MainViewController.h"
#import "YPImage.h"

@implementation DataManager

+(void)initializeDataManagementWithOptions:(NSDictionary *)options inMainController:(MainViewController *)mainController{
    // PARSE
    [Parse setApplicationId:@"cJDOYQQLWxG7LpLal0HXloB30YEKVTv1ek2AwM8o" clientKey:@"kAIDv7HgWyqfkUCgcRDxgNNLBaMYZWV1ovJcWAM9"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:options];
    [PFFacebookUtils initializeFacebook];
    
//    // DB
    [dbManager checkAndCreateDatabase];
    
    [self sincMomentsCompletion:^{
        NSLog(@"moments sinc");
        [self sincPlacesCompletion:^{
            NSLog(@"places sinc");
            [self sincAllImagesWithCompletion:^{
                NSLog(@"images sinc");
               [mainController loadRegionsWithFinalBlock:^{
               [mainController loadContainers];
               }];
            }];
        }];
    }];

 
}


#pragma mark - private methods -
+(void)saveNewMoment:(Moment *)moment inPlace:(Place *)place
        successParse:(void(^)(void))successParseBlock successDB:(void(^)(Moment *finalDBMoment))successDBBlock
        failureParse:(void(^)(void))failureParseBlock failureDB:(void(^)(void))failureDBBlock
{
 
    NSAssert([moment validateMoment], @"moment not valid");
    NSAssert([place validatePlace], @"place not valid");
    
    [dbManager addMomentInDB:moment];
    [dbManager addPlaceInDB:place];
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
+(void)compareDBMomentsIDS:(NSArray *)dbids withParseOnes:(NSArray *)parseMoments
{
    
    for (Moment *singleMoment in parseMoments) {
        Moment *resultMoment = [Moment sincronizeDBMoment:nil withParseMoment:singleMoment];
        if (![dbids containsObject:singleMoment.uniqueid]) {
            [dbManager addMomentInDB:resultMoment];
        }else
        {
            // update moment
            [dbManager updateMoment:resultMoment];
        }
    }
    /*
     ///// test this function..>>
     for (NSString *singleId in dbids )
     {
     BOOL check = NO;
     for (Moment *singleMoment in parseMoments) {
     if ([singleMoment.uniqueid isEqualToString:singleId]) {
     check = YES;
     }
     }
     
     if (!check) {
     //remove moment from DB..
     }
     }*/
}
#pragma mark - public methods -
+(void)saveImage:(NSData *)imageData inPlace:(Place *)place withData:(NSDictionary *)data
                        imageUUID:(NSString *)uuid
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
        
        [dbManager saveImage:imageData withContainerName:finalDBMoment.containerName andUniqueid:uuid];
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
+(void)saveContact:(Contact *)contact inPlace:(Place *)place
                    completionDBBlock:(void(^)(void))completionDB
                    remoteCompletionBlock:(void(^)(void))remoteCompletion
                    remoteFailureBlock:(void(^)(void))remoteFailure
{
   // NSAssert([contact validateContact], @"contact is not valid");
    // contacts are saved ONLY in DB
    
    NSAssert(contact.containerName, @"contact has not container");
    if (contact.containerName.length) {
        [dbManager saveContact:contact];
    }
    completionDB();
}

#pragma mark - data retriving - 

//MOMENTS
+(void)sincMomentsCompletion:(void(^)(void))completionBlock
{
    //DB
    NSArray *momentDB = (NSArray *)[dbManager elementsFromTableName:@"Moments"];
    __block NSMutableArray *dbIds = [[NSMutableArray alloc]init];
     for (NSDictionary *item in momentDB) {
        [dbIds addObject:[item objectForKey:@"uniqueid"]];
    }
    __block NSMutableArray *parseIds = [NSMutableArray new];
    // PARSE
    [ParseData getMomentsFromServerSuccess:^(NSArray *moments) {
        for (Moment*momentParse in moments) {
            [parseIds addObject:momentParse];
        }
        if (moments.count == 0) {
            [dbManager deleteAllfromTable:@"Moments"];
            NSLog(@"all moments canceled from db");
        }else{
        //////compare moments ids//////
        [self compareDBMomentsIDS:dbIds withParseOnes:parseIds];
        }
        completionBlock();
    } failure:^{
    
    }];
}
+(void)sincPlacesCompletion:(void(^)(void))completionBlock
{
    [ParseData getPlacesFromServerSuccess:^(NSArray *placesRemote) {
        if (placesRemote.count == 0) {
            [dbManager deleteAllfromTable:@"Places"];
            NSLog(@"all places canceles from db");
            
        }else{
        [self loadPlaces:^(NSArray *placesDB) {

            for (Place *remotePlace in placesRemote) {
                BOOL existInDB = NO;
                for (Place *dbPlace in placesDB) {
                    if ([remotePlace isEqualToPlace:dbPlace]) {
                        existInDB = YES;
                    }
                }
                if (!existInDB) {
                    [dbManager addPlaceInDB:remotePlace];
                }
            }

        } fromContainerName:nil];
        }
        completionBlock();
    } failure:^{
        
    }];
}
+(void)sincAllImagesWithCompletion:(void(^)(void))completion
{
    [ParseData loadImageWithContainerName:nil success:^(NSArray *arrayFile) {
        
        [self loadFastDBImages:^(NSArray *images) {
            
            for (YPImage *remoteImage in arrayFile) {
                BOOL check = NO;
                if (images.count == 0) {
                    // addImage
                    if (remoteImage.fileData) {
                        PFFile *dataFile = remoteImage.fileData;
                        [dataFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                            
                            if (!error) {
                                [dbManager saveImage:imageData withContainerName:remoteImage.containerName andUniqueid:remoteImage.uniqueid];
                            }else
                            {
                                NSLog(@"error : %@",error.description);
                            }
                        }];
                    }

                }else
                {
                for (YPImage *dbImage in images) {
                    if ([remoteImage.uniqueid isEqualToString:dbImage.uniqueid]) {
                        check = YES;
                    }
                }
                    if (!check) {
                        if (remoteImage.fileData) {
                            PFFile *dataFile = remoteImage.fileData;
                            [dataFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                                if (!error) {
                                    NSAssert(imageData, @"imageData is nil");
                                    [dbManager saveImage:imageData withContainerName:remoteImage.containerName andUniqueid:remoteImage.uniqueid];

                                }
                            }];
                        }
                        
                    }else
                    {
                        /*
                        PFFile *dataFile = remoteImage.fileData;

                        [dataFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                            if (!error) {
                                remoteImage.imageData = [UIImage imageWithData:imageData];
                                NSLog(@"remote container name : %@",remoteImage.containerName);
                                // update image
                                [dbManager updateImage:remoteImage];
                              
                            }
                        }];
                        */
                        [dbManager updateImage:remoteImage];
                    }
 
                }
            }
            completion();
        } fromContainerName:nil];
    } error:^{
        
    }];

}
// IMAGES
+(void)loadFastDBImages:(void(^)(NSArray *images))imagesBlock fromContainerName:(NSString *)containerName
{
    imagesBlock([dbManager imagesFromContainer:containerName]);
    // downloading in asinc the images
}

// NOTES
+(void)loadNotes:(void(^)(NSArray *notes))notesBlock fromContainerName:(NSString *)containerName
{
    notesBlock([dbManager loadNotesFromContainerName:containerName]);
}
// PLACES
+(void)loadPlaces:(void(^)(NSArray *places))placesBlock fromContainerName:(NSString *)containerName
{
    NSArray *placesDB = (NSArray *)[dbManager elementsFromTableName:@"Places"];
    NSMutableArray *places = [NSMutableArray new];
    for (NSDictionary *obj in placesDB) {
        Place *singlePlace  = [Place new];
        singlePlace.lat = [obj objectForKey:@"lat"];
        singlePlace.lng = [obj objectForKey:@"lng"];
        singlePlace.name = [obj objectForKey:@"name"];
        singlePlace.regionRadius =  (int)[[obj objectForKey:@"region_radius"] integerValue];
        singlePlace.uniqueid = [obj objectForKey:@"uniqueid"];
        if ([singlePlace validatePlace]) {
            [places addObject:singlePlace];
        }
    }
    placesBlock(places);
}
//MOMENTS
+(void)loadMoments:(void(^)(NSArray *moments))momentsBlock fromContainerName:(NSString *)containerName
{
    NSArray *momentsDB = (NSArray *)[dbManager elementsFromTableName:@"Moments"];
    NSMutableArray *moments = [NSMutableArray new];
    
    [self loadPlaces:^(NSArray *places) {
        
        
        for (NSDictionary *obj in momentsDB) {
            Moment *singleMoment = [Moment new];
            singleMoment.containerName = [obj objectForKey:@"container_name"];
            singleMoment.startDate = [obj objectForKey:@"startDate"];
            singleMoment.endDate = [obj objectForKey:@"endDate"];
            singleMoment.uniqueid = [obj objectForKey:@"uniqueid"];
            singleMoment.name = [obj objectForKey:@"name"];
            singleMoment.info = @{};
            
            BOOL check = FALSE;
            for (Place *singlePlace in places) {
                if ([singlePlace.uniqueid isEqualToString:[obj objectForKey:@"place_id"]]) {
                    singleMoment.place = singlePlace;
                    check = TRUE;
                    break;
                }
            }
            
            if (!check) {
                NSLog(@"non esiste il posto");
            }
            if ([singleMoment validateMoment]) {
                [moments addObject:singleMoment];
            }
        }
        
        momentsBlock(moments);

    } fromContainerName:nil];
    
  
}
// CONTACTS
+(void)loadContacts:(void(^)(NSArray *contacts))contactsBlock fromContainerName:(NSString *)containerName
{
   contactsBlock([dbManager loadContactsFromContainerName:containerName]);
    
}

+(id)retriveDataFromDBTable:(NSString *)tableName
{
  return [dbManager elementsFromTableName:tableName];
}

@end

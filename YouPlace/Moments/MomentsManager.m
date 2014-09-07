//
//  MomentsManager.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 13/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "MomentsManager.h"
#import "MomentContainerFactory.h"
#import "Moment.h"
#import "MomentContainer.h"

@interface MomentsManager()
@property (nonatomic,strong) NSArray *allMoments;
@end
static NSMutableDictionary *allMomentsDict;

@implementation MomentsManager
-(NSArray *)allMoments
{
    if (!_allMoments) {
        _allMoments = [[NSArray alloc]init];
    }
    return _allMoments;
}
- (instancetype)initWithMoments:(NSArray *)moments
{
    self = [super init];
    if (self) {
        self.allMoments = moments;
        allMomentsDict= [[NSMutableDictionary alloc]initWithDictionary:[self divideAllMomentByPlaceIdInDictionary]];

    }
    return self;
}

-(NSArray *)getArrayOfMomentsFromPlaceIdKey:(NSString *)key
{
    NSArray *arrayOfMoments = [allMomentsDict objectForKey:key];
    
    return arrayOfMoments;
}
- (MomentContainer *)momentContainerFromMoments:(NSArray *)moments
{
    NSString *key ;
    for (Moment *mom  in moments) {
        if (key != nil && ![key isEqualToString:mom.containerName]) {
            NSLog(@"two moments have same place id but different container!!");
        }else{
            key =  mom.containerName;
        }
    }

  return [MomentContainerFactory getIstanceFromKey:key];
    
}
-(NSArray *)filtersMomentsForKey:(NSString *)filterKey andValue:(id)value
{
      if (self.allMoments.count > 0) {
        
        NSMutableArray *filterArray = [[NSMutableArray alloc]init];
        
        for (Moment *singleMoment in self.allMoments) {
            
            if ([filterKey isEqualToString:@"name"]) {
                
                if ([value isKindOfClass:[NSString class]]) {
                    if ([singleMoment.name isEqualToString:value]) {
                        [filterArray addObject:singleMoment];
                    }
                }
            }else if ([filterKey isEqualToString:@"start_date"])
            {
                
            }else if ([filterKey isEqualToString:@"end_date"])
            {
                
            }else if ([filterKey isEqualToString:@"place_id"])
            {
                if ([value isKindOfClass:[NSString class]]) {
                    
                    if ([singleMoment.place.uniqueid isEqualToString:value]) {
                        [filterArray addObject:singleMoment];
                    }
                }
                
            }else if ([filterKey isEqualToString:@"uniqueid"])
            {
                if ([value isKindOfClass:[NSString class]]) {
                    if ([singleMoment.uniqueid isEqualToString:value]) {
                        [filterArray addObject:singleMoment];
                    }
                }
            }else if ([filterKey isEqualToString:@"info"])
            {
                
            }
        }
          return (NSArray *)filterArray;
    }else
        return nil;
}

-(NSArray *)momentsContainersFromArray:(NSArray *)arrayOfArray andCurrentPlace:(Place *)place
{
    
    NSMutableArray *mutableArrayOfMomentContainer = [[NSMutableArray alloc]init];

    for (NSArray *singleArray in arrayOfArray) {
        MomentContainer *momContainer = [[MomentContainer alloc]initWithMoments:singleArray];
        // register single momentContainer in factory
        if (momContainer.uniqueID) {
            [MomentContainerFactory registerMomentContainer:momContainer withKey:momContainer.name];
        }else
        {
            NSLog(@"moment container without id and not registered");
        }

        if ([place.uniqueid isEqualToString:momContainer.mainPlaceId]) {
            momContainer.currentPlace = YES;
        }
        [mutableArrayOfMomentContainer addObject:momContainer];
    }
    //add an empty moment container for place not known
    
    return (NSArray *)mutableArrayOfMomentContainer;
}


#pragma mark - dividing moments -

-(NSDictionary *)divideAllMomentByPlaceIdInDictionary
{
    NSMutableDictionary *mutDictionary = [[NSMutableDictionary alloc]init];
    
    for (Moment *moment in self.allMoments) {
        BOOL check = FALSE;
        for (NSString *stringKey in mutDictionary) {
            NSMutableArray *mutArray = [mutDictionary objectForKey:stringKey];
            
            if ([moment.place.uniqueid isEqualToString:stringKey]) {
                [mutArray addObject:moment];
                check = TRUE;
                break;
            }
        }
        if (!check) {
            NSMutableArray *mutarray = [[NSMutableArray alloc]initWithArray:@[moment]];
            NSString *stringAssert  = [NSString stringWithFormat:@"place :%@ has not uniqueid",moment];
            NSAssert(moment.place.uniqueid, stringAssert);
            [mutDictionary setObject:mutarray forKey:moment.place.uniqueid];
        }
    }
    
    return (NSDictionary *)mutDictionary;
    
}
-(NSArray *)divideAllMomentsByPlaces
{
    NSMutableArray *momentPlacesArray = [[NSMutableArray alloc]init];
    for (Moment *moment in self.allMoments) {
        BOOL check = FALSE;
        for (NSMutableArray *mutArray in momentPlacesArray) {
            Moment *mom = [mutArray objectAtIndex:0];
            if ([moment.place isEqualToPlace:mom.place]) {
                [mutArray addObject:moment];
                check = TRUE;
                break;
            }
        }
        if (!check) {
            NSMutableArray *mutarray = [[NSMutableArray alloc]initWithArray:@[moment]];
            [momentPlacesArray addObject:mutarray];
        }
    }
    return (NSArray *)momentPlacesArray;
}
-(NSArray *)divideAllMomentsByMomentContainer
{
    NSMutableArray *momentContainerArray = [[NSMutableArray alloc]init];
    for (Moment *moment in self.allMoments) {
        BOOL check = FALSE;
        for (NSMutableArray *mutArray in momentContainerArray) {
            Moment *mom = [mutArray objectAtIndex:0];
            if ([moment.containerName isEqualToString:mom.containerName]) {
                [mutArray addObject:moment];
                check = TRUE;
                break;
            }
        }
        if (!check) {
            NSMutableArray *mutarray = [[NSMutableArray alloc]initWithArray:@[moment]];
            [momentContainerArray addObject:mutarray];
        }
    }
    return (NSArray *)momentContainerArray;
}

@end

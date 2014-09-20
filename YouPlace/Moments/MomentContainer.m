//
//  MomentContainer.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 14/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "MomentContainer.h"
#import "Moment.h"
#import "Utils.h"

@interface MomentContainer()

@property (nonatomic,strong) NSMutableArray *dataSourceMoments;




@end

@implementation MomentContainer

-(NSMutableArray *)dataSourceMoments
{
    if (!_dataSourceMoments) {
        _dataSourceMoments = [[NSMutableArray alloc]init];
    }
    return _dataSourceMoments;
}

-(BOOL)isEqualToMomentContainer:(MomentContainer *)momentContainer
{
    if ([momentContainer.uniqueID isEqualToString:self.uniqueID]) {
        return YES;
    }else
        return NO;
}

- (instancetype)initWithMoments:(NSArray *)moments
{
    self = [super init];
    if (self) {
        
        for (id object in moments) {
            if ([object isKindOfClass:[Moment class]]) {
                Moment *ptMoment = (Moment *)object;
                if (!self.mainPlaceId.length) {
                    //NSLog(@"setto la property col posto : %@",ptMoment.place.name);
                    self.mainPlaceId = ptMoment.place.uniqueid;
                    [self.dataSourceMoments addObject:ptMoment];
                }else
                {
                    if (![self.mainPlaceId isEqualToString:ptMoment.place.uniqueid]) {
                        
                   //     NSLog(@"error: the moments is not part of this set >> moment added ");
                        [self.dataSourceMoments addObject:ptMoment];

                    }else
                    {
                       // NSLog(@"ok: momento aggiunto al dataSource");
                        //NSLog(@"posto : %@",ptMoment.place.name);
                        [self.dataSourceMoments addObject:ptMoment];
                    }
                }
            }
        }

        if (self.dataSourceMoments.count > 0 ) {
            [self setAllProperties];
        }
        
    }
    return self;
}

-(void)setAllProperties{
    
    Moment *firstMoment = [self.dataSourceMoments objectAtIndex:0];
    self.momentIdTest = firstMoment.uniqueid;
    self.name = firstMoment.containerName;
    self.placeName = self.name;
    self.numberOfMoments = (int) self.dataSourceMoments.count;
    self.uniqueID = [Utils createUUID];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [firstMoment.place.lat doubleValue];
    coordinate.longitude = [firstMoment.place.lng doubleValue];
    self.coordinate = coordinate;

}


@end

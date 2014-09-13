//
//  Moment.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 12/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "Moment.h"
#import "Utils.h"
#import "ParseData.h"

@implementation Moment

//-(NSString *)description
//{
//    NSString *uniqueid_str = [NSString stringWithFormat:@"uniqueid : %@",self.uniqueid];
//    NSString *name_str = [NSString stringWithFormat:@"name : %@",self.name];
//    NSString *place_str = [NSString stringWithFormat:@"place : %@",self.place];
//    NSString *startDate_str = [NSString stringWithFormat:@"startDate : %@",self.startDate];
//    NSString *endDate_str = [NSString stringWithFormat:@"endDate : %@",self.endDate];
//    NSString *info_str = [NSString stringWithFormat:@"info : %@",self.info];
//    NSString *container_id_str = [NSString stringWithFormat:@"containerID : %@",self.containerID];
//
//   return [NSString stringWithFormat:@"%@\n %@\n %@\n %@\n %@\n %@\n %@\n",uniqueid_str,name_str,place_str,startDate_str,endDate_str,info_str,container_id_str];
//}
-(NSString *)description
{
    NSString *name_str = [NSString stringWithFormat:@"Moment with name : %@",self.name];

   return name_str;
}
-(Moment *)validateMoment
{
    if (!self || !self.name || !self.uniqueid || !self.place || !self.startDate || !self.endDate || !self.info || !self.place.uniqueid) {
        
        NSAssert(false, @"moment is not complete");
        return nil;
    }
    else
        return self;
}


+(Moment *)newMomentwithPlace:(Place *)place withData:(NSDictionary *)data
{
    NSString *name = kDefaultMomentName;
    if ([data objectForKey:kMomentNameKEY]) {
        name = [data objectForKey:kMomentNameKEY];
    }
    NSString *containerName = place.name;
    if ([data objectForKey:kMomentContainerNameKEY]) {
        containerName  = [data objectForKey:kMomentContainerNameKEY];
    }
    
    NSString *noteContent = kDefaultMomentNoteContent;
    
    if ([data objectForKey:kMomentNoteContentKEY]) {
        noteContent = [data objectForKey:kMomentNoteContentKEY];
    }
    
    Moment *newMoment = [[Moment alloc]init];
    newMoment.place = place;
    newMoment.name = name;
    newMoment.uniqueid = [Utils createUUID];
    newMoment.containerName = containerName;
    newMoment.info  = @{@"note":noteContent};
    newMoment.startDate =[NSDate date];
    newMoment.endDate = [NSDate date];
    
    return newMoment;
}
//saving new moment
+(void)saveCurrentMomentInPlace:(Place *)place withData:(NSDictionary *)data withFinal:(void(^)(Moment *moment))finalBlock errorBlock:(void(^)(void))error
{

    if([place validatePlace]){
        
        Moment *ptMoment = [self newMomentwithPlace:place withData:data];
        
        [ParseData saveNewMoment:ptMoment inNewPlace:place success:^{
            NSLog(@"momento %@ salvato",ptMoment.uniqueid);
            finalBlock(ptMoment);
        } failure:^{
            error();
            NSLog(@"moment non salvato");
        }];
        
    }else
    {
        error();
        NSLog(@"current place senza unique id");
    }
}
@end


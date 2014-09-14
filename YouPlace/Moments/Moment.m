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
-(NSString *)debugDescription
{
   return self.containerName;
}
-(Moment *)validateMoment
{
    if (!self || !self.name || !self.uniqueid || !self.place || !self.startDate || !self.endDate || !self.info || !self.place.uniqueid || !self.containerName) {
        
        NSAssert(false, @"moment is not complete");
        return nil;
    }
    else
        return self;
}
+(Moment *)sincronizeDBMoment:(Moment *)db_moment withParseMoment:(Moment *)parse_moment
{
    Moment *finalMoment = [Moment new];
    
    NSAssert(parse_moment.uniqueid, @"parse moment has not uniqueid");
    
    
    //UNIQUEID
    finalMoment.uniqueid = parse_moment.uniqueid;
    
    //PLACE
    if (parse_moment.place != nil) {
        finalMoment.place = parse_moment.place;
    }else
    {
        finalMoment.place = db_moment.place;
    }
    
    //START DATE
    if (parse_moment.startDate != nil) {
        finalMoment.startDate = parse_moment.startDate;
    }else
    {
        finalMoment.startDate = db_moment.startDate;
    }
    
    //END DATE
    if (parse_moment.endDate != nil) {
        finalMoment.endDate = parse_moment.endDate;
    }else
    {
        finalMoment.endDate = db_moment.endDate;
    }
    
    // INFO
    if (parse_moment.info != nil) {
        finalMoment.info = parse_moment.info;
    }else
    {
        finalMoment.info = db_moment.info;
    }

    //NAME
    if (parse_moment.name != nil) {
        finalMoment.name = parse_moment.name;
    }else
    {
        finalMoment.name = db_moment.name;
    }
    
    //CONTAINER NAME
    if (parse_moment.containerName != nil) {
        finalMoment.containerName = parse_moment.containerName;
    }else
    {
        finalMoment.containerName = db_moment.containerName;
    }
    
    finalMoment = [finalMoment validateMoment];
    
    
    return finalMoment;
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


//
//  Moment.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 12/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import "MomentContainer.h"

static NSString *kMomentNameKEY = @"name";
static NSString *kMomentNoteContentKEY = @"noteContent";
static NSString *kMomentContainerNameKEY = @"contName";

static NSString *kDefaultMomentName = @"defualt_moment_name";
static NSString *kDefaultMomentNoteContent = @"defualt_moment_note_content";

@interface Moment : NSObject

@property (nonatomic,strong) NSString *uniqueid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) Place *place;
@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSDate *endDate;
@property (nonatomic,strong) NSDictionary *info;
@property (nonatomic,strong) NSString *containerName;

-(Moment *)validateMoment;
+(void)saveCurrentMomentInPlace:(Place *)place withData:(NSDictionary *)data withFinal:(void(^)(Moment *moment))finalBlock errorBlock:(void(^)(void))error;

+(Moment *)newMomentwithPlace:(Place *)place withData:(NSDictionary *)data;

@end

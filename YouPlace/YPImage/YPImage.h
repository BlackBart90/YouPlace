//
//  YPImage.h
//  YouPlace
//
//  Created by Jacopo Pappalettera on 14/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface YPImage : NSObject
@property (nonatomic,strong) NSString * momentid;
@property (nonatomic,strong) NSString * placeid;
@property (nonatomic,strong) NSString *uniqueid;

@property (nonatomic,strong) UIImage * imageData;

@property (nonatomic,strong) PFFile *fileData;
@property (nonatomic,strong) NSString * containerName;
@end

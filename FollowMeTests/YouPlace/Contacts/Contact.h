//
//  Contact.h
//  YouPlace
//
//  Created by Jacopo Pappalettera on 13/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject
@property (nonatomic,strong) NSString *uniqueid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *surname;
@property (nonatomic,strong) NSString *tel;
@property (nonatomic,strong) NSString *link_fb;
@property (nonatomic,strong) NSString *link_tw;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *note;
@property (nonatomic,strong) NSString *containerName;


-(Contact *)validateContact;

@end

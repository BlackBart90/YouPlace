//
//  Contact.m
//  YouPlace
//
//  Created by Jacopo Pappalettera on 13/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "Contact.h"

@implementation Contact


-(Contact *)validateContact
{
    if (!self || !self.name || !self.uniqueid || !self.surname || !self.tel || !self.email || !self.ling_tw || !self.link_fb || !self.address || !self.note || !self.containerName) {
        
        NSAssert(false, @"contact is not complete");
        return nil;
    }
    else
        return self;
}
@end

//
//  Note.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 07/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "Note.h"

@implementation Note


-(Note *)validateNote
{
    if (!self || !self.content || !self.uniqueID || !self.momentID || !self.title) {
        
        NSAssert(false, @"note is not complete");
        return nil;
    }
    else
        return self;
}

@end

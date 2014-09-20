//
//  YPImage.m
//  YouPlace
//
//  Created by Jacopo Pappalettera on 14/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "YPImage.h"

@implementation YPImage

-(YPImage *)validateImage
{
    if (!self || !self.containerName || !self.uniqueid) {
        NSString *imageStringAssert = [NSString  stringWithFormat:@"image in %@:  is not complete",self.containerName];
        NSAssert(false,imageStringAssert);
        return nil;
    }
    else
        return self;
}
@end

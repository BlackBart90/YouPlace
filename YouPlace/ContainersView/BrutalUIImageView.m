//
//  BrutalImage.m
//  YouPlace
//
//  Created by Jacopo Pappalettera on 16/09/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "BrutalUIImageView.h"

@implementation BrutalUIImageView
@synthesize image;

- (void)setImage:(UIImage *)anImage {
    [image autorelease];
    image = [anImage retain];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGSize imageSize = image.size;
    CGSize viewSize = CGSizeMake(rect.size.width*2.5, rect.size.height*2.5); // size in which you want to draw
    
    float hfactor = imageSize.width / viewSize.width;
    float vfactor = imageSize.height / viewSize.height;
    
    float factor = fmax(hfactor, vfactor);
    
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    float newWidth = imageSize.width / factor;
    float newHeight = imageSize.height / factor;
    
    CGRect newRect = CGRectMake(0,0, newWidth, newHeight);
    
    [image drawInRect:newRect];
}
-(CGSize)getImageSize:(CGSize )imgViewSize andActualImageSize:(CGSize )actualImageSize {
    
    // imgViewSize = size of view in which image is to be drawn
    // actualImageSize = size of image which is to be drawn
    
    CGSize drawImageSize;
    
    if (actualImageSize.height > actualImageSize.width) {
        drawImageSize.height = imgViewSize.height;
        drawImageSize.width = actualImageSize.width/actualImageSize.height * imgViewSize.height;
        
    }else {
        drawImageSize.width = imgViewSize.width;
        drawImageSize.height = imgViewSize.width * actualImageSize.height /  actualImageSize.width;
    }
    return drawImageSize;
}
- (void)dealloc {
    [image release];
    image  = nil;
    [super dealloc];
}

@end
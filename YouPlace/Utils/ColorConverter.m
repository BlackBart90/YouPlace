//
//  ColorConverter.m
//  MakeItApp
//
//  Created by Bogdan Moldovan on 04/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColorConverter.h"

@implementation ColorConverter

+ (UIColor *) colorWithHexString: (NSString *) hex  
{  
    if ([hex isEqual: @"clear"]) 
    {
        return [UIColor clearColor];
    }
    else
    {
    
        NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        // String should be 6 or 8 characters  
        if ([cString length] < 6) return [UIColor grayColor];  
    
        // strip 0X if it appears  
        if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];  
    
        if ([cString length] != 6) return  [UIColor grayColor];  
    
        // Return transparent color

    
        // Separate into r, g, b substrings  
        NSRange range;  
        range.location = 0;  
        range.length = 2;  
        NSString *rString = [cString substringWithRange:range];  
    
        range.location = 2;  
        NSString *gString = [cString substringWithRange:range];  
    
        range.location = 4;  
        NSString *bString = [cString substringWithRange:range];  
    
        // Scan values  
        unsigned int r, g, b;  
        [[NSScanner scannerWithString:rString] scanHexInt:&r];  
        [[NSScanner scannerWithString:gString] scanHexInt:&g];  
        [[NSScanner scannerWithString:bString] scanHexInt:&b];  
    
        return [UIColor colorWithRed:((float) r / 255.0f)  
                               green:((float) g / 255.0f)  
                               blue:((float) b / 255.0f)  
                               alpha:1.0f];  
    }
} 

+ (UIColor *) colorWithHexStringAndAlpha: (NSString *) hex  alphaChannel: (CGFloat) _alpha 
{  
    if ([hex isEqual:@"clear"]) 
    {
        return [UIColor clearColor];
    }
    else
    {
        
        NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        // String should be 6 or 8 characters  
        if ([cString length] < 6) return [UIColor grayColor];  
        
        // strip 0X if it appears  
        if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];  
        
        if ([cString length] != 6) return  [UIColor grayColor];  
        
        // Return transparent color
        
        // Separate into r, g, b substrings  
        NSRange range;  
        range.location = 0;  
        range.length = 2;  
        NSString *rString = [cString substringWithRange:range];  
        
        range.location = 2;  
        NSString *gString = [cString substringWithRange:range];  
        
        range.location = 4;  
        NSString *bString = [cString substringWithRange:range];  
        
        // Scan values  
        unsigned int r, g, b;  
        [[NSScanner scannerWithString:rString] scanHexInt:&r];  
        [[NSScanner scannerWithString:gString] scanHexInt:&g];  
        [[NSScanner scannerWithString:bString] scanHexInt:&b];  
        
        return [UIColor colorWithRed:((float) r / 255.0f)  
                               green:((float) g / 255.0f)  
                                blue:((float) b / 255.0f)  
                               alpha:_alpha];  
    }
}

+ (UIColor *) darkerColorForColor:(UIColor *) color
{
    CGFloat r, g, b, a;
    if ([color getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}

@end

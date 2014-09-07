//
//  ColorConverter.h
//  MakeItApp
//
//  Created by Bogdan Moldovan on 04/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface ColorConverter : NSObject

+ (UIColor *) colorWithHexString: (NSString *) hex;
+ (UIColor *) colorWithHexStringAndAlpha: (NSString *) hex  alphaChannel: (CGFloat) _alpha;

+ (UIColor *) darkerColorForColor:(UIColor *) color;

@end

//
//  MIAPopUpFactory.h
//  FwkTest
//
//  Created by Jacopo on 25/07/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIABasePopUp;

@interface MIAPopUpFactory : NSObject
+(MIABasePopUp *)popUpFromString:(NSString *)popUpName layoutArgs:(NSDictionary *)layoutArgs dataArgs:(NSDictionary *)dataArgs;

@end

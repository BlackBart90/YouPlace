//
//  PopUpFactory.h
//  FwkTest
//
//  Created by Jacopo on 25/07/14.
//  
//

#import <Foundation/Foundation.h>

@class BasePopUp;

@interface PopUpFactory : NSObject
+(BasePopUp *)popUpFromString:(NSString *)popUpName layoutArgs:(NSDictionary *)layoutArgs dataArgs:(NSDictionary *)dataArgs;

@end

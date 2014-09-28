//
//  PopUp.h
//  FwkTest
//
//  Created by Jacopo on 04/08/14.
//  
//

#import <Foundation/Foundation.h>
#import "BasePopUp.h"

@interface PopUp : NSObject

- (instancetype)initInController:(UIViewController *)controller type:(NSString *)type message:(NSString *)message andTitle:(NSString *)title;
- (void)show;
- (void)close;

@property (nonatomic,strong) NSString *openingAnimationName;
@property (nonatomic,strong) NSString *endingAnimationName;
@property (nonatomic,weak) id <BasePopUpProtocol> delegate;

@end

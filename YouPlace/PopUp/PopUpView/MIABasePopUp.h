//
//  MIABasePopUp.h
//  FwkTest
//
//  Created by Jacopo on 25/07/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MIABasePopUp;

@protocol MIABasePopUpProtocol <NSObject>

-(void)closePopUp:(MIABasePopUp *)popUp;

@end


@interface MIABasePopUp : UIView

@property (nonatomic,strong) NSDictionary *dataArgs;
@property (nonatomic,strong) NSDictionary *layoutArgs;
@property (nonatomic,strong) NSObject *renderer;

@property (nonatomic,weak) id <MIABasePopUpProtocol> delegate;
-(void)loadCustomArgs:(NSDictionary *)dictionaryArgs;



@end

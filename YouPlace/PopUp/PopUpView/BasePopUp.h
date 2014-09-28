//
//  MIABasePopUp.h
//  FwkTest
//
//  Created by Jacopo on 25/07/14.
//  
//

#import <UIKit/UIKit.h>

@class BasePopUp;

@protocol BasePopUpProtocol <NSObject>

-(void)closePopUp:(BasePopUp *)popUp;

@end


@interface BasePopUp : UIView

@property (nonatomic,strong) NSDictionary *dataArgs;
@property (nonatomic,strong) NSDictionary *layoutArgs;
@property (nonatomic,strong) NSObject *renderer;

@property (nonatomic,weak) IBOutlet UILabel *name_category_label;
@property (nonatomic,weak) IBOutlet UILabel *place_label;
@property (nonatomic,weak) IBOutlet UILabel *coordinates_label;

@property (nonatomic,weak) IBOutlet UILabel *name_category_label_value;
@property (nonatomic,weak) IBOutlet UILabel *place_label_value;
@property (nonatomic,weak) IBOutlet UILabel *coordinates_label_value;


@property (nonatomic,strong) NSString *cat_name;
@property (nonatomic,strong) NSString *place_name;
@property (nonatomic,strong) NSString *coordinates;



@property (nonatomic,weak) id <BasePopUpProtocol> delegate;
-(void)loadCustomArgs:(NSDictionary *)dictionaryArgs;



@end

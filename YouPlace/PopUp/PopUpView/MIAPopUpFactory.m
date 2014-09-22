//
//  MIAPopUpFactory.m
//  FwkTest
//
//  Created by Jacopo on 25/07/14.
//  Copyright (c) 2014 William Izzo. All rights reserved.
//

#import "MIAPopUpFactory.h"
#import "MIABasePopUp.h"

#import "PhotoPopUp.h"
#import "NotePopUp.h"

static NSDictionary * popUpFactoryClassList;
@implementation MIAPopUpFactory
+(void)load
{
    popUpFactoryClassList = @{@"photo_pop_up":[PhotoPopUp class],
                              @"note_pop_up":[NotePopUp class]};
}
+(MIABasePopUp *)popUpFromString:(NSString *)popUpName layoutArgs:(NSDictionary *)layoutArgs dataArgs:(NSDictionary *)dataArgs
{
    Class popUpClass = [popUpFactoryClassList objectForKey:popUpName];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([popUpClass class]) bundle:nil];
    MIABasePopUp *popUp = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    NSMutableDictionary *allArgs = [[NSMutableDictionary alloc]init];
    if (layoutArgs) {
        [allArgs setObject:layoutArgs forKey:@"layout_args"];
    }
    if (dataArgs) {
        [allArgs setObject:dataArgs forKey:@"data_args"];

    }
    [popUp loadCustomArgs:(NSDictionary *)allArgs];
    return popUp;
}
@end

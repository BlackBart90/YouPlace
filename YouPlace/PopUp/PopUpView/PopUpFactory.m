//
//  PopUpFactory.m
//  FwkTest
//
//  Created by Jacopo on 25/07/14.
//  
//

#import "PopUpFactory.h"
#import "BasePopUp.h"

#import "PhotoPopUp.h"
#import "NotePopUp.h"

static NSDictionary * popUpFactoryClassList;
@implementation PopUpFactory
+(void)load
{
    popUpFactoryClassList = @{@"photo_pop_up":[PhotoPopUp class],
                              @"note_pop_up":[NotePopUp class]};
}
+(BasePopUp *)popUpFromString:(NSString *)popUpName layoutArgs:(NSDictionary *)layoutArgs dataArgs:(NSDictionary *)dataArgs
{
    Class popUpClass = [popUpFactoryClassList objectForKey:popUpName];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([popUpClass class]) bundle:nil];
    BasePopUp *popUp = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
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

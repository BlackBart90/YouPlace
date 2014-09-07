//
//  FileUploaderManager.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 19/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "FileUploaderManager.h"
#import "ParseData.h"
#import "AES/NSData+CommonCrypto.h"

@interface FileUploaderManager ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,weak) id <FileUploaderProtocol> delegate;

@end

@implementation FileUploaderManager
static FileUploaderManager *sharedInstance;

+(FileUploaderManager *)sharedClass
{
    @synchronized(self)
    {
        if (!sharedInstance)
            sharedInstance = [[FileUploaderManager alloc]init];
        return sharedInstance;
    }
}

-(void)newImageFromController:(UIViewController *)controller andDelegate:(id)delegate
{
    self.delegate = delegate;
    UIImagePickerControllerSourceType type;
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypeCamera] == YES)
    {
        type =UIImagePickerControllerSourceTypeCamera;
    }
    else if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary] == YES){
        type = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    // Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
    imagePicker.sourceType =  type;
    imagePicker.allowsEditing = NO;
    // Delegate is self
    imagePicker.delegate = self;
    
    // Show image picker
    [controller presentViewController:imagePicker animated:YES completion:^{}];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    //UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    
    // imageData =  [imageData AES256EncryptedDataUsingKey:@"ciao" error:nil];
    // for decrypt example
    // data = [NSMutableData dataWithData:[data decryptedAES256DataUsingKey:PROTECTION_KEY error:nil]];
    [self.delegate didUploadFileData:imageData];

 
}

@end

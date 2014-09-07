//
//  FileUploaderManager.h
//  FollowMe
//
//  Created by Jacopo Pappalettera on 19/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SinglePlaceView.h"

@protocol FileUploaderProtocol <NSObject>

- (void)didUploadFileData:(NSData *)dataFile;

@end


@interface FileUploaderManager : NSObject


+(FileUploaderManager *)sharedClass;

-(void)newImageFromController:(UIViewController *)controller andDelegate:(id)delegate;

@end

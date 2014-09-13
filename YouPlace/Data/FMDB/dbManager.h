//
//  dbManager.h
//  AlTriangolo
//
//  Created by Jacopo on 25/05/13.
//  Copyright (c) 2013 Jacopo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Note.h"
#import "Moment.h"
#import "Contact.h"

static NSString *kDBpath = @"/Library/Caches/youplace.sqlite";


@interface dbManager : NSObject

+(void)checkAndCreateDatabase;

+(NSMutableArray *)elementsFromTableName:(NSString *)table;
+(NSMutableArray *)getArrayFromQuery:(NSString *)query;

+(void)deleteAllfromTable:(NSString *)tableName;


+(void)deleteItem:(int)number fromTable:(NSString *)tablename;

+(void)updateObjectToTableDoppieWithNumero:(int)numero andQnt:(int)qnt;



+(void)saveImage:(NSData *)imageData withContainerName:(NSString *)containerName andUniqueid:(NSString *)uuid;
+(void)addNoteInDB:(Note *)note;
+(void)addMomentInDB:(Moment *)moment;
+(void)addPlaceInDB:(Place *)place;
+(void)saveContact:(Contact *)contact;

//retriving data
+(NSArray *)imagesFromContainer:(NSString *)containerName;


@end




//  dbManager.m
//  AlTriangolo
//
//  Created by Jacopo on 25/05/13.
//  Copyright (c) 2013 Jacopo. All rights reserved.
//

#import "dbManager.h"
#import <sqlite3.h>


@implementation dbManager

+(void)checkAndCreateDatabase
{
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"youplace" ofType:@"sqlite"];
        
    NSError *error = nil;
        if (![[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:dbPath error:&error]) {
            NSLog(@"Error: %@", error);
        }
    }
    else
    {
        NSLog(@"DB copied");
    }
}
#pragma mark - MOMENTS and PLACES -
+(void)addMomentInDB:(Moment *)moment
{
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Moments (uniqueid,container_name,place_id,name,startDate,endDate) VALUES ('%@','%@','%@','%@','%@','%@')",moment.uniqueid,moment.containerName,moment.place.uniqueid,moment.name,moment.startDate,moment.endDate];
    [db beginTransaction];
    [db executeUpdate:sql];
    [db commit];
    [db close];
    
}

+(void)updateMoment:(Moment *)newMoment
{
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE Moments SET container_name = '%@',place_id = '%@',name = '%@',startDate = '%@',endDate = '%@' WHERE uniqueid = '%@'",newMoment.containerName,newMoment.place.uniqueid,newMoment.name,newMoment.startDate,newMoment.endDate,newMoment.uniqueid];
    [db beginTransaction];
    //db.traceExecution = YES;

    [db executeUpdate:sql];
    [db commit];
    [db close];
    
}
+(void)addPlaceInDB:(Place *)place
{
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Places (uniqueid,lat,lng,name,region_radius) VALUES ('%@','%@','%@','%@','%i')",place.uniqueid,place.lat,place.lng,place.name,place.regionRadius];
    [db beginTransaction];
    [db executeUpdate:sql];
    [db commit];
    [db close];
}

#pragma mark - NOTES -
+(void)addNoteInDB:(Note *)note
{
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];

    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Notes (title,content,uniqueid,container_name,momentid) VALUES ('%@','%@','%@','%@','%@')",note.title,note.content,note.uniqueID,note.containerName,note.momentID];
    [db beginTransaction];
    [db executeUpdate:sql];
    [db commit];
    [db close];

}
+(NSArray *)loadNotesFromContainerName:(NSString *)containerName
{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Notes WHERE container_name == '%@'",containerName];
    
    NSMutableArray *notes = [NSMutableArray new];
    NSArray *data = [self getArrayFromQuery:query];
    
    for (NSDictionary *dataItem in data) {
        Note *note = [Note new];
        note.containerName = [dataItem objectForKey:@"container_name"];
        note.content = [dataItem objectForKey:@"content"];
        note.title = [dataItem objectForKey:@"title"];
        note.uniqueID = [dataItem objectForKey:@"uniqueid"];
        note.momentID = [dataItem objectForKey:@"momentid"];
        
        if ([note validateNote]) {
            [notes addObject:note];
        }else
        {
            NSLog(@"note not loaded correctly");
        }
    }
    return notes;
}

#pragma mark - PHOTOS -
+(void)saveImage:(NSData *)imageData withContainerName:(NSString *)containerName andUniqueid:(NSString *)uuid
{
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    [db beginTransaction];
    [db executeUpdate:@"INSERT OR REPLACE INTO Photos (image,uniqueid,container_name) VALUES (?,?,?)",imageData,uuid,containerName];
    [db commit];
    [db close];

}
+(NSArray *)imagesFromContainer:(NSString *)containerName
{
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Photos"];
    if (containerName) {
        query  = [NSString stringWithFormat:@"SELECT * FROM Photos WHERE container_name == '%@'",containerName];
    }
    NSMutableArray *images = [[NSMutableArray alloc]init];
    NSArray *data = [self getArrayFromQuery:query];
    for (NSDictionary *obj in data) {
        YPImage*singleImage = [YPImage new];
        if ([UIImage imageWithData:[obj objectForKey:@"image"]]) {
            singleImage.imageData = [UIImage imageWithData:[obj objectForKey:@"image"]];

            singleImage.containerName = [obj objectForKey:@"container_name"];
            singleImage.uniqueid = [obj objectForKey:@"uniqueid"];
        
            singleImage = [singleImage validateImage]; // is not usefull
            [images addObject:singleImage];
        }
    }
    
    return images;
}
+(void)updateImage:(YPImage *)newYPImage
{
    
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
 //   NSData *dataImage = [NSData dataWithData:UIImagePNGRepresentation(newYPImage.imageData)];

    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    [db beginTransaction];
    //db.traceExecution = YES;
    //@"UPDATE Photos SET image = ?,container_name = ? WHERE uniqueid = ?",dataImage,newYPImage.containerName,newYPImage.uniqueid
    [db executeUpdate:@"UPDATE Photos SET container_name = ? WHERE uniqueid = ?",newYPImage.containerName,newYPImage.uniqueid];
    [db commit];
    [db close];
    
}
#pragma mark - CONTACTS -
+(void)saveContact:(Contact *)contact
{
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Contacts (uniqueid,name,surname,tel,link_fb,link_tw,address,email,note,container_name) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",contact.uniqueid,contact.name,contact.surname,contact.tel,contact.link_fb,contact.link_tw,contact.address,contact.email,contact.note,contact.containerName];
    
    [db beginTransaction];
    [db executeUpdate:sql];
    [db commit];
    [db close];
    
}
+(NSArray *)loadContactsFromContainerName:(NSString *)containerName
{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Contacts WHERE container_name == '%@'",containerName];
    
    NSMutableArray *contacts = [NSMutableArray new];
    NSArray *data = [self getArrayFromQuery:query];
    
    for (NSDictionary *dataItem in data) {
        
        Contact *cont = [Contact new];
        cont.containerName = [dataItem objectForKey:@"container_name"];
        cont.address = [dataItem objectForKey:@"address"];
        cont.email = [dataItem objectForKey:@"email"];
        cont.link_fb = [dataItem objectForKey:@"link_fb"];
        cont.link_tw = [dataItem objectForKey:@"link_tw"];
        cont.name = [dataItem objectForKey:@"name"];
        cont.note = [dataItem objectForKey:@"note"];
        cont.tel=  [dataItem objectForKey:@"tel"];
        cont.uniqueid = [dataItem objectForKey:@"uniqueid"];
        cont.surname = [dataItem objectForKey:@"surname"];
        
        [contacts addObject:cont];
        /*
        if ([cont validateContact]) {
            [contacts addObject:cont];
        }else
        {
            NSLog(@"contacts not loaded correctly");
        }*/
        cont = nil;
    }
    return (NSArray *)contacts;
}

// method not yet tested
-(void)updateContactFromContact:(Contact *)newContact
{
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    [db beginTransaction];
   
    [db executeUpdate:@"UPDATE Contacts SET address = ?,email = ?,link_fb = ?,link_tw = ?,name = ?,note = ?,tel = ?,surname = ?,container_name = ? WHERE uniqueid = ?",newContact.address,newContact.email,newContact.link_fb,newContact.link_tw,newContact.name,newContact.note,newContact.tel,newContact.surname,newContact.containerName,newContact.uniqueid];
    
    [db commit];
    [db close];
    
}
#pragma mark - other -

+(NSMutableArray *)elementsFromTableName:(NSString *)table;
{
    NSMutableArray *lista = [[NSMutableArray alloc]init];
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@",table];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    FMResultSet *s = [db executeQuery:sqlString];
    while ([s next]) {
        NSDictionary *record = [s resultDictionary];
        [lista addObject:record];
    }
    [s close];
    [db close];
    return lista;
    
}
+(NSMutableArray *)getArrayFromQuery:(NSString *)query
{
    NSMutableArray *lista = [[NSMutableArray alloc]init];
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"Al_Triangolo" ofType:@"sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    FMResultSet *s = [db executeQuery:query];
    
    while ([s next]) {
        NSDictionary *record = [s resultDictionary];
        [lista addObject:record];
    }
    [s close];
    [db close];
    return lista;
}

+(void)deleteItem:(int)number fromTable:(NSString *)tableName
{
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    NSString *deleteSql = [[NSString alloc] initWithFormat:@"DELETE FROM %@  WHERE numero='%i'",tableName,number];
    [db beginTransaction];
    [db executeUpdate:deleteSql];
    [db commit];
    [db close];
    
}
+(void)deleteAllfromTable:(NSString *)tableName
{
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    NSString *deleteSql = [[NSString alloc] initWithFormat:@"DELETE  FROM %@ " ,tableName];
    [db beginTransaction];
    [db executeUpdate:deleteSql];
    [db commit];
    [db close];
}
+(void)updateObjectToTableDoppieWithNumero:(int)numero andQnt:(int)qnt
{
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    NSString *numeroString = [NSString stringWithFormat:@"'%i'",numero];
    NSString *qntString = [NSString stringWithFormat:@"'%i'",qnt];
    NSString *sql = [NSString stringWithFormat:@"UPDATE doppie SET qnt = %@ WHERE numero  = %@",qntString,numeroString];
    NSLog(@"sql update card in 'doppie' : %@",sql);
    
    [db beginTransaction];
    [db executeUpdate:sql];
    [db commit];
    [db close];
    
}

/*
+ (BOOL)recordExists:(NSString *) value inTable:(NSString *) tableName 
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/Library/Caches/TopCars.sqlite", NSHomeDirectory()];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS cnt FROM %@ WHERE numero='%@'",tableName, value];
    FMResultSet *rsdata = [db executeQuery:sql];
    
    while ([rsdata next])
    {
        return [[rsdata stringForColumn:@"cnt"] intValue] > 0 ? YES : NO;
        
    }
    
    return NO;
}
 */

@end

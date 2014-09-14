

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
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Photos WHERE container_name == '%@'",containerName];
    
    NSMutableArray *images = [NSMutableArray new];
    NSArray *data = [self getArrayFromQuery:query];
    for (NSDictionary *obj in data) {
        UIImage *singleImage = [UIImage imageWithData:[obj objectForKey:@"image"]];
        [images addObject:singleImage];
    }
    
    return images;
}
#pragma mark - CONTACTS -
+(void)saveContact:(Contact *)contact
{
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Contacts (uniqueid,name,surname,tel,link_fb,link_tw,address,email,note,container_name) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",contact.uniqueid,contact.name,contact.surname,contact.tel,contact.link_fb,contact.ling_tw,contact.address,contact.email,contact.note,contact.containerName];
    [db beginTransaction];
    [db executeUpdate:sql];
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

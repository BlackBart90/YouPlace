

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
#pragma mark - MOMENTS -
+(void)addMomentInDB:(Moment *)moment
{
    
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Moments (uniqueid) VALUES ('%@')",moment.uniqueid];
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

    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Notes (title,content,uniqueid,momentid) VALUES ('%@','%@','%@','%@')",note.title,note.content,note.uniqueID,note.momentID];
    [db beginTransaction];
    [db executeUpdate:sql];
    [db commit];
    [db close];

}
#pragma mark - photos -
// test
+(void)saveImage:(NSData *)imageData
{
    NSString *dbPath = [NSString stringWithFormat:@"%@%@", NSHomeDirectory(),kDBpath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    [db beginTransaction];
    [db executeUpdate:@"INSERT OR REPLACE INTO Photos (image) VALUES (?)",imageData];
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

//
//  FMDatabase+Update.m
//  DDCoupon
//
//  Created by ryan on 11-6-28.
//  Copyright 2011 DDmap. All rights reserved.
//

#import "FMDatabase+Update.h"
#import "FMDatabaseAdditions.h"

#define DB_USER_VERSION 105

@implementation FMDatabase (Update)

+ (void)databaseUpdate {
	
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *realDBPath = [docDir stringByAppendingPathComponent:@"fmdb.db"];
    
    FMDatabase *db_ = [FMDatabase databaseWithPath:realDBPath];
	
	[db_ open];
    NIF_TRACE(@"---%d",[db_ userVersion]);
    if([db_ userVersion] < 105) {
        NSString *schemaPath = [[NSBundle mainBundle] pathForResource:@"HMQuanKuSchema" ofType:@"sql"];
        NSString *schemas = [NSString stringWithContentsOfFile:schemaPath encoding:NSUTF8StringEncoding error:nil];
        
        [db_ executeUpdate:schemas];
        //[db_ executeBatch:schemas error:&dbError];
       
        // added json_cached table 
        NSString *sql = @"\
        CREATE  TABLE  IF NOT EXISTS json_caches(\n\
        row_id              INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL,\n\
        type                VCHAR,\n\
        key                 TEXT NOT NULL UNIQUE,\n\
        value               BLOB,\n\
        saved_time          DOUBLE DEFAULT CURRENT_TIMESTAMP,\n\
        validity_duration   DOUBLE,\n\
        readed_times        INTEGER DEFAULT 0\n\
        )";
        [db_ executeUpdate:sql];
        
        sql = @"\
        CREATE  TABLE  IF NOT EXISTS failed_urls(\n\
        row_id              INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL,\n\
        version             VCHAR,\n\
        appid               VCHAR,\n\
        primarykey          VCHAR,\n\
        lat                 VCHAR,\n\
        lon                 VCHAR,\n\
        mid                 VCHAR,\n\
        userid              VCHAR,\n\
        macaddr             VCHAR,\n\
        apicallindex        VCHAR,\n\
        pageref             VCHAR,\n\
        requesturl          VCHAR\n\
        )";
        [db_ executeUpdate:sql];
        NSError *error = nil;
        [db_ executeUpdate:sql];
        
        if (error) {
            NIF_TRACE(@"%@",error);
        }
        
        [db_ setUserVersion:DB_USER_VERSION];
    }
}

@end

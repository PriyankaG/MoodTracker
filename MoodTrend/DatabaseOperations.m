//
//  DatabaseOperations.m
//  MoodTrend
//
//  Created by Administrator on 13/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatabaseOperations.h"

@implementation DatabaseOperations

@synthesize database;


// Fetch the database from the device
+(NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"database.sql"];
}


// Open the Database, if it already exists; else, create a new one
-(void) openDB {
    
    DatabaseOperations *dbOps;
    
    if (sqlite3_open([[dbOps filePath] UTF8String], &database) != SQLITE_OK ) {
        sqlite3_close(database);
        NSAssert(0, @"Database failed to open.");
        
    } else {
        NSLog(@"Successfully opened the database");
    }
}


// Create the database table, if not already exists, to persist data
-(void) createTableNamed:(NSString *) tableName
              withField1:(NSString *) field1
              withField2:(NSString *) field2 {
    char *error;
    NSString *createQuery = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT, '%@' TEXT);", tableName, field1, field2];

    if (sqlite3_exec(database, [createQuery UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Table could not be created.");
        NSLog(@"Table creation failed");
        
    } else {
        NSLog(@"Table created successfully");
    }
}


/**
 * Insert data into the table. Input the data entered by the user.
 * tableName   (NSString)   - the table into which the data is inserted into
 * withField1  (NSString)   - the name of the first field i.e. 'mood' here
 * field1Value (NSString)   - the value chosen by the user for 'mood'. This can be one of either 'great', 'okay', or 'bad'.
 * withField2  (NSString)   - the name of the 2nd field i.e. 'sleep' here
 * field2Value (NSString)   - the value chosen by the user for 'sleep', which can be either 'yes' or 'no'
 */
-(void) insertRecordIntoTableNamed: (NSString *) tableName
                        withField1: (NSString *) field1
                       field1Value: (NSString *) field1Value
                        withField2: (NSString *) field2
                       field2Value: (NSString *) field2Value {
    NSString *query = [NSString stringWithFormat:
                       @"INSERT OR REPLACE INTO '%@' ('%@', '%@') VALUES (?,?)", tableName, field1, field2];
    const char *queryInsertion = [query UTF8String];
    
    // Now, insert the placeholder values
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, queryInsertion, -1, &statement, nil) == SQLITE_OK ) {
        sqlite3_bind_text(statement, 1, [field1Value UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 2, [field2Value UTF8String], -1, NULL);
    }
    NSLog(@"Updated the table");
    
    // Execute the statement
    if ( sqlite3_step ( statement ) != SQLITE_DONE ) {
        NSAssert(0, @"Error updating table");
        NSLog(@"Error updating the table");
    }
    sqlite3_finalize(statement);
}


/** 
 * Fetches all the data from the specified table
 * @param  tableName  (NSString)  - the table name from which to fetch the values
 * @return (NSArray)              - an array with the values:
 *                                                          1. Total num of rows in the table
 *                                                          2. Count of rows with the value of mood1
 *                                                          3. Count of rows with the value of mood2
 *                                                          4. Count of rows with the value of mood3
 *                                                     in that order
 */
-(NSArray *) getAllRowsFromTableNamed: (NSString *) tableName {
    
    sqlite3_stmt *statement;
    
    NSString *queryFetch = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    
    // Fetch the data from the 'MoodTrack' table
    if (sqlite3_prepare_v2 ( database, [queryFetch UTF8String], -1, &statement, nil ) == SQLITE_OK) {
        
        NSInteger rowsCount = 0;
        NSInteger mood1Count = 0;
        NSInteger mood2Count = 0;
        NSInteger mood3Count = 0;
        
        // Iterate through the rows
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            rowsCount = rowsCount+1;
            
            // Get the first value, i.e., that of 'mood'
            char *field1 = (char *) sqlite3_column_text(statement, 0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String: field1];
            
            if ([field1Str isEqualToString:@"1"]) {
                mood1Count = mood1Count + 1;
                
            } else if ([field1Str isEqualToString:@"2"]) {
                mood2Count = mood2Count + 1;
                
            } else if ([field1Str isEqualToString:@"3"]) {
                mood3Count = mood3Count + 1;
            } 
            
            // Get the value of 'sleep'
            char *field2 = (char *) sqlite3_column_text(statement, 1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String: field2];
            
            NSString *str = [[NSString alloc] initWithFormat:@"%@ - %@", field1Str, field2Str];
            NSLog(@"%@", str);
            
            field1Str = nil;
            field2Str = nil;
            str = nil;
        }
        
        // delete the compiled statement from memory
        sqlite3_finalize(statement);
        
        NSLog(@"Num of rows:%d ; Mood1:%d ; Mood2:%d ; Mood3:%d", rowsCount, mood1Count, mood2Count, mood3Count);

        NSNumber *n1 = [NSNumber numberWithInteger:(rowsCount)];
        NSLog(@"n1:%@", n1);
        
        return [[NSArray alloc] initWithObjects:
                                    [NSNumber numberWithInteger:(rowsCount)], 
                                    [NSNumber numberWithInteger:(mood1Count)],
                                    [NSNumber numberWithInteger:(mood2Count)],
                                    [NSNumber numberWithInteger:(mood3Count)],
                                    [NSNumber numberWithInteger:(mood3Count)],
                                    nil];
    }
}

@end

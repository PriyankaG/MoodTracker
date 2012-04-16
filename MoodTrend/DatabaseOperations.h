//
//  DatabaseOperations.h
//  MoodTrend
//
//  Created by Administrator on 13/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DatabaseOperations : NSObject

@property (nonatomic) sqlite3 *database;


// Method to fetch the database that's present in the device
-(NSString *) filePath; 

// Method to open the database
-(void) openDB;

// Method to create the table with two fields
-(void) createTableNamed:(NSString *) tableName
              withField1:(NSString *) field1
              withField2:(NSString *) field2;

// Method to insert records into the database
-(void) insertRecordIntoTableNamed: (NSString *) tableName
                        withField1: (NSString *) field1
                       field1Value: (NSString *) field1Value
                        withField2: (NSString *) field2
                       field2Value: (NSString *) field2Value;

// Method to fetch all rows from the table
-(NSArray *) getAllRowsFromTableNamed: (NSString *) tableName;


@end

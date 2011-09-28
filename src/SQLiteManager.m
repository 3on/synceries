//
//  SQLiteManager.m
//  synceries
//
//  Created by Anita on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLiteManager.h"

@interface SQLiteManager (PrivateMethods)
-(void) checkDbExists;
-(void) insertSheet:(GDataEntrySpreadsheetDoc*) sheet withDb:(sqlite3*) db;
-(void) clean;
-(void) print_err:(sqlite3*) db;
@end

@implementation SQLiteManager

static NSString* dbName = @"synceriesDb.sql";
static NSString* dbPath = nil;

-(id) init {
    if (!dbPath) {
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        dbPath = [[documentsDir stringByAppendingPathComponent:dbName] retain];
        [self checkDbExists];
    }
    return self;
}

-(void) checkDbExists {
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:dbPath]) {
        return;
    }
    NSString* databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
    [fm removeItemAtPath:dbPath error:nil];
    [fm copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
}

-(void) deleteRow:(Row*) row {
    sqlite3* db;
    const char* query = "DELETE FROM sheetData WHERE entryId=?";
    if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK) {
        sqlite3_stmt* ppStmt;
        if (sqlite3_prepare(db, query, -1, &ppStmt, nil) == SQLITE_OK) {
            sqlite3_bind_text(ppStmt, 1, [[row entryId] UTF8String], -1, SQLITE_TRANSIENT);
            if (sqlite3_step(ppStmt) != SQLITE_DONE) {
                [self print_err:db];
            }
        } else {
            [self print_err:db];
        }
    }
    sqlite3_close(db);
}

-(void) deleteSheet:(Sheet*) sheet {
    sqlite3* db;
    const char* query = "DELETE FROM sheetData WHERE entryId=?";
    const char* query2 = "DELETE FROM sheets WHERE id=?";
    if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK) {
        sqlite3_stmt* ppStmt;
        if (sqlite3_prepare(db, query, -1, &ppStmt, nil) == SQLITE_OK) {
            sqlite3_bind_int(ppStmt, 1, [sheet id]);
            if (sqlite3_step(ppStmt) != SQLITE_DONE) {
                [self print_err:db];
            }
        } else {
            [self print_err:db];
        }

        if (sqlite3_prepare(db, query2, -1, &ppStmt, nil) == SQLITE_OK) {
            sqlite3_bind_int(ppStmt, 1, [sheet id]);
            if (sqlite3_step(ppStmt) != SQLITE_DONE) {
                [self print_err:db];
            }
        } else {
            [self print_err:db];
        }
    }
    sqlite3_close(db);
}

-(void) deleteRowsForSheet:(Sheet*) sheet {
    sqlite3* db;
    const char* query = "DELETE FROM sheetData WHERE sheetId=?";
    if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK) {
        sqlite3_stmt* ppStmt;
        if (sqlite3_prepare(db, query, -1, &ppStmt, nil) == SQLITE_OK) {
            sqlite3_bind_int(ppStmt, 1, [sheet id]);
            int sqliteStatus = sqlite3_step(ppStmt);
            if (sqliteStatus != SQLITE_DONE) {
                [self print_err:db];
            }
        } else {
            [self print_err:db];
        }
    }
    sqlite3_close(db);
}

-(void) fillSheetData:(Sheet*) sheet {
    sqlite3* db;
    const char* query = "SELECT itemName, entryId, checked, uploadEditLink, eTag FROM sheetData WHERE sheetId=?";
    if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK) {
        sqlite3_stmt* ppStmt;
        NSMutableArray* rowData = [[[NSMutableArray alloc] init] autorelease];
        [sheet setListData2:rowData];
        if (sqlite3_prepare(db, query, -1, &ppStmt, nil) == SQLITE_OK) {
            sqlite3_bind_int(ppStmt, 1, [sheet id]);
            int sqliteStatus = sqlite3_step(ppStmt);
            while (sqliteStatus == SQLITE_ROW) {
                Row* row = [[Row alloc] init];
                [row setChecked:sqlite3_column_int(ppStmt, 2)];
                [row setItemName:[NSString stringWithUTF8String:(char*)sqlite3_column_text(ppStmt, 0)]];
                [row setEntryId:[NSString stringWithUTF8String:(char*)sqlite3_column_text(ppStmt, 1)]];
                if (sqlite3_column_text(ppStmt, 3)) {
                    [row setUploadEditLink:[NSURL URLWithString:[NSString stringWithUTF8String:(char*)sqlite3_column_text(ppStmt, 3)]]];
                    [row setETag:[NSString stringWithUTF8String:(char*)sqlite3_column_text(ppStmt, 4)]];
                }
                [row setPersisted:true];
                [rowData addObject:row];
                sqliteStatus = sqlite3_step(ppStmt);
            }
        } else {
            [self print_err:db];
        }
    }
    sqlite3_close(db);
}

-(void) saveSheetData:(Sheet *)sheet {
    sqlite3* db;
    const char* query = "INSERT OR REPLACE INTO sheetData (sheetId, itemName, checked, entryId, uploadEditLink, eTag) VALUES(?,?,?,?,?,?)";
    if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK) {
        sqlite3_stmt* ppStmt;
        NSArray* rowData = sheet.listData2;
        for (NSUInteger i = 0; i < [rowData count]; i++) {
            if (sqlite3_prepare(db, query, -1, &ppStmt, nil) == SQLITE_OK) {
                Row* row = [rowData objectAtIndex:i];
                sqlite3_bind_int(ppStmt, 1, sheet.id);
                sqlite3_bind_text(ppStmt, 2, [[row itemName] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(ppStmt, 3, [row checked]);
                sqlite3_bind_text(ppStmt, 4, [[row entryId] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(ppStmt, 5, [[[row uploadEditLink] absoluteString] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(ppStmt, 6, [[row eTag] UTF8String], -1, SQLITE_TRANSIENT);

                if (sqlite3_step(ppStmt) != SQLITE_DONE) {
                    [self print_err:db];
                } else {
                    [row setPersisted:true];
                }
            } else {
                [self print_err:db];
            }
        }
    }
    sqlite3_close(db);
}

-(void) print_err:(sqlite3*) db {
    NSLog(@"%s", sqlite3_errmsg(db));
}

-(void) clean {
    sqlite3* db;
    const char* query = "DELETE FROM sheets WHERE 1";
    const char* query2 = "DELETE FROM sheetData WHERE 1";
    if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK) {
        sqlite3_stmt* ppStmt;
        if (sqlite3_prepare_v2(db, query, -1, &ppStmt, nil) == SQLITE_OK) {
            if (SQLITE_DONE == sqlite3_step(ppStmt)) {
                if (sqlite3_prepare_v2(db, query2, -1, &ppStmt, nil) == SQLITE_OK) {
                    if (SQLITE_DONE != sqlite3_step(ppStmt)) {
                        [self print_err:db];
                    }
                } else {
                    [self print_err:db];
                }
            } else {
                [self print_err:db];
            }
        } else {
            [self print_err:db];
        }
    }
    sqlite3_close(db);
}

-(void) saveSheets:(GDataFeedDocList*) feed {
    sqlite3* db;
    [self clean];
    if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK) {
        NSArray* entries = [feed entries];
        for (NSInteger i = [entries count] - 1; i >= 0; i--) {
            [self insertSheet:[entries objectAtIndex:i] withDb:db];
        }
    }
    sqlite3_close(db);
}

-(void) insertSheet:(GDataEntrySpreadsheetDoc*) sheet withDb:(sqlite3*) db{
    NSString* queryFmt = @"INSERT OR REPLACE INTO sheets (worksheetsLinkUrl, title, lastSave) VALUES ('%@','%@',CURRENT_TIME)";
    sqlite3_stmt* ppStmt;
    NSString* link = [[[sheet worksheetsLink] URL] absoluteString];
    NSString* title = [[sheet title] stringValue];
    
    if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:queryFmt, link, title] UTF8String], -1, &ppStmt, nil) == SQLITE_OK) {
        if (SQLITE_DONE != sqlite3_step(ppStmt)) {
            [self print_err:db];
        }
    } else {
        [self print_err:db];
    }
}

-(NSArray*) listSheets {
    sqlite3* db;
    const char* query = "SELECT id, title, worksheetsLinkUrl FROM sheets ORDER BY title ASC";
    NSMutableArray* result = nil;
    if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK) {
        sqlite3_stmt* ppStmt;
        if (sqlite3_prepare_v2(db, query, -1, &ppStmt, nil) == SQLITE_OK) {
            result = [[[NSMutableArray alloc] init] autorelease];
            while (SQLITE_ROW == sqlite3_step(ppStmt)) {
                int idt = sqlite3_column_int(ppStmt, 0);
                const unsigned char* title = sqlite3_column_text(ppStmt, 1);
                const unsigned char* link = sqlite3_column_text(ppStmt, 2);
                Sheet* s = [[Sheet alloc] initWithId:idt Title:[NSString stringWithUTF8String:(char*)title] andLink:[NSString stringWithUTF8String:(char*)link]];
                [result addObject:s];
            }
        } else {
            [self print_err:db];
        }
    }
    sqlite3_close(db);
    return result;
}

@end

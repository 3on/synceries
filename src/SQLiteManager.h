//
//  SQLiteManager.h
//  synceries
//
//  Created by Anita on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataDocs.h"
#import "GDataSpreadsheet.h"
#import "Sheet.h"
#import "Row.h"
#import <sqlite3.h>

@interface SQLiteManager : NSObject {

}

-(void) saveSheets:(GDataFeedDocList*) feed;
-(NSArray*) listSheets;
-(void) saveSheetData:(Sheet*) sheet;
-(void) fillSheetData:(Sheet*) sheet;
-(void) deleteSheet:(Sheet*) sheet;
-(void) deleteRow:(Row*) row;
-(void) deleteRowsForSheet:(Sheet*) sheet;
@end

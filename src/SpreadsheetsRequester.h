//
//  SpreadsheetsRequester.h
//  synceries
//
//  Created by Anita on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataSpreadsheet.h"
#import "Sheet.h"
#import "Row.h"

@interface SpreadsheetsRequester : NSObject {
    GDataServiceGoogleSpreadsheet* service;
}

-(id) initWithAuthToken:(id) token;
-(void) requestDataWithWorksheetsLink:(NSURL*) link callbackDelegate:(id) delegate withMethod:(SEL) selector sheet:(Sheet*) doc;
-(GDataServiceTicket*) requestWorksheetFeed:(NSURL*) feedUrl callbackDelegate:(id) delegate withMethod:(SEL) hector;

-(void) updateEntryForRow:(Row*) row;
-(void) addRow:(Row*) row inSheet:(Sheet*) sheet;
-(void) deleteRow:(Row*) row;
@end

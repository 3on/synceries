//
//  SpreadsheetsRequester.m
//  synceries
//
//  Created by Anita on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpreadsheetsRequester.h"


@implementation SpreadsheetsRequester
-(id) initWithAuthToken:(id) token {
    service = [[GDataServiceGoogleSpreadsheet alloc] init];
    [service setAuthorizer:token];
    return self;
}

-(void) dealloc {
    [super dealloc];
    [service release];
}

-(void) requestDataWithWorksheetsLink:(NSURL*) link callbackDelegate:(id) delegate withMethod:(SEL) selector sheet:(Sheet *)doc {
    GDataServiceTicket* ticket = [self requestWorksheetFeed:link callbackDelegate:self withMethod:@selector(fetchFirstWorksheetData:inFeed:error:)];
    [ticket setProperty:doc forKey:@"sheet"];
    [ticket setProperty:delegate forKey:@"delegate"];
    [ticket setProperty:NSStringFromSelector(selector) forKey:@"selector"];
}

-(GDataServiceTicket*) requestWorksheetFeed:(NSURL*) feedUrl callbackDelegate:(id) delegate withMethod:(SEL) hector {
    return [service fetchFeedWithURL:feedUrl delegate:delegate didFinishSelector:hector];
}

-(void) fetchFirstWorksheetData:(GDataServiceTicket*) ticket inFeed:(GDataFeedWorksheet*) feed error:(NSError*) err {
    if (err) {
        if (err.code == 304) {
            id delegate = [ticket propertyForKey:@"delegate"];
            SEL selector = NSSelectorFromString([ticket propertyForKey:@"selector"]);
            NSInvocation* callbackInvocation = [NSInvocation invocationWithMethodSignature:[delegate methodSignatureForSelector:selector]];
            [callbackInvocation setTarget:delegate];
            [callbackInvocation setSelector:selector];
            [callbackInvocation setArgument:&ticket atIndex:2];
            [callbackInvocation setArgument:&err atIndex:4];
            [callbackInvocation invoke];
        } else {
            NSLog(@"%@", err);
        }
    } else {
        GDataEntryWorksheet* sheet = [feed firstEntry];
        GDataServiceTicket* newTicket = [service fetchFeedWithURL:[sheet listFeedURL] delegate:[ticket propertyForKey:@"delegate"] didFinishSelector:NSSelectorFromString([ticket propertyForKey:@"selector"])];
        [newTicket setProperty:[ticket propertyForKey:@"sheet"]  forKey:@"sheet"];
    }
}

-(void) addRow:(Row*) row inSheet:(Sheet*) sheet {
    NSString* xmlString = [NSString stringWithFormat:@"<entry xmlns=\"http://www.w3.org/2005/Atom\" xmlns:gsx=\"http://schemas.google.com/spreadsheets/2006/extended\"><gsx:item>%@</gsx:item>", [row itemName]];
    xmlString = [xmlString stringByAppendingString:([row checked] ? @"<gsx:checked>x</gsx:checked></entry>" : @"</entry>")];
    GDataEntrySpreadsheetList* entry = [[GDataEntrySpreadsheetList alloc] initWithXMLElement:[[GDataXMLElement alloc] initWithXMLString:xmlString error:nil] parent:nil];
    GDataServiceTicket* ticket = [service fetchEntryByInsertingEntry:entry forFeedURL:[sheet postLink] delegate:self didFinishSelector:@selector(updateRow:entry:error:)];
    [ticket setUserData:row];
}

-(void) deleteRow:(Row*) row {
    [service deleteResourceURL:[row uploadEditLink] ETag:[row eTag] delegate:self didFinishSelector:@selector(updateRow:entry:error:)];
}

-(void) logDelete:(GDataServiceTicket*) ticket entry:(id) entry error:(NSError*) err {
    if (err) {
        NSLog(@"%@", err);
    } else {
        NSLog(@"Deleted row.");
    }
}

-(void) updateRow:(GDataServiceTicket*) ticket entry:(GDataEntrySpreadsheetList*) entry error:(NSError*) err {
    if (err) {
        NSLog(@"%@", err);
    } else {
        NSLog(@"Added row with entry id: %@", [entry identifier]);
        Row* row = [ticket userData];
        [row setEntryId:[entry identifier]];
        [row setETag:[entry ETag]];
        [row setUploadEditLink:[[entry editLink] URL]];
    }
}

-(void) updateEntryForRow:(Row *)row {
    GDataEntrySpreadsheetList* entry = [row gDataEntryForUpdate];
    GDataServiceTicket* ticket = [service fetchEntryByUpdatingEntry:entry forEntryURL:[row uploadEditLink] delegate:self didFinishSelector:@selector(updateRow:entry:error:)];
    [ticket setUserData:row];
}

-(void) updateEntryWithTicket:(GDataServiceTicket*) ticket entry:(GDataEntrySpreadsheetList*) entry error:(NSError*) err {
    if (err) {
        NSLog(@"%@", err);
    } else {
        [entry setCustomElements:[[ticket userData] customElements]];
        [service fetchEntryByUpdatingEntry:entry delegate:self didFinishSelector:@selector(logCompletion:data:error:)];
    }
}

-(void) logCompletion:(GDataServiceTicket*) ticket data:(GDataEntrySpreadsheetList*) entry error:(NSError*) err {
    if (err) {
        NSLog(@"%@", err);
    } else {
        NSLog(@"Update successfully sent to Spreadsheets API, %@", entry);
    }
}

@end

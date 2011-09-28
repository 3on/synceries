//
//  GDocsRequester.m
//  synceries
//
//  Created by Anita on 05/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GDocsRequester.h"


@implementation GDocsRequester

-(id) initWithAuthToken:(id) token {
    service = [[GDataServiceGoogleDocs alloc] init];
    [service setAuthorizer:token];
    return self;
}

-(void) dealloc {
    [super dealloc];
    [service release];
}

-(void) createDirectoryWithName:(NSString*) dirName delegate:(id) delegate selector:(SEL) selector {
    GDataEntryFolderDoc* directory = [[GDataEntryFolderDoc alloc] init];
    [directory setTitleWithString:dirName];
    [service fetchEntryByInsertingEntry:directory forFeedURL:[NSURL URLWithString:@"https://docs.google.com/feeds/default/private/full/"] delegate:delegate didFinishSelector:selector];
}

-(void) createNewSheet:(Sheet*) sheet collectionPostLink:(NSURL*) collection {
    GDataEntrySpreadsheetDoc* doc = [[GDataEntrySpreadsheetDoc alloc] init];
    [doc setTitleWithString:[sheet title]];
    GDataServiceTicket* ticket = [service fetchEntryByInsertingEntry:doc forFeedURL:collection delegate:self didFinishSelector:@selector(updateDocEntry:entry:error:)];
    [ticket setUserData:sheet];
}

-(void) updateDocEntry:(GDataServiceTicket*) ticket entry:(GDataEntrySpreadsheetDoc*) doc error:(NSError*) err {
    if (err) {
        NSLog(@"%@", err);
    } else {
        Sheet* sheet = [ticket userData];
        [sheet setWorksheetLink:[[[doc worksheetsLink] URL] absoluteString]];
    }
}

-(void) logCompletion:(GDataServiceTicket*) ticket entry:(GDataEntryBase*) doc error:(NSError*) err {
    if (err) {
        NSLog(@"%@", err);
    } else {
        NSLog(@"Success! %@", doc);
    }
}

-(void) fetchDirectoryFeedWithName:(NSString*) dirName delegate:(id) delegate selector:(SEL) selector {
    NSMutableString* url = [[NSMutableString alloc] initWithString:@"https://docs.google.com/feeds/default/private/full/-/folder?title="];
    [url appendString:dirName];
    [url appendString:@"&title-exact=true&showfolders=true&max-results=1"];
    GDataServiceTicket* ticket = [service fetchFeedWithURL:[NSURL URLWithString:url] delegate:self didFinishSelector:@selector(findCollectionWithTicket:inFeed:error:)];
    [ticket setProperty:delegate forKey:@"delegate"];
    [ticket setProperty:dirName forKey:@"dirName"];
    [ticket setProperty:NSStringFromSelector(selector) forKey:@"selector"];
    [url release];
}

-(void) findCollectionWithTicket:(GDataServiceTicket*) ticket inFeed:(GDataFeedDocList*) feed error:(NSError*) error {
    if (!error) {
        NSMutableString* str = [[NSMutableString alloc] initWithString:@"https://docs.google.com/feeds/default/private/full/"];
        id delegate = [ticket propertyForKey:@"delegate"];
        GDataEntryFolderDoc* folder = [[feed entries] objectAtIndex:0];
        if (!folder) {
            [self createDirectoryWithName:[ticket propertyForKey:@"dirName"] delegate:self selector:@selector(handleNewDirectory:entry:error:)];
        } else {
            NSString* identifier = [folder resourceID];
            [str appendString:identifier];
            NSURL* nsurl = [[NSURL alloc] initWithString:[str stringByAppendingString:@"/contents/-/spreadsheet"]];
            [service fetchFeedWithURL:nsurl delegate:delegate didFinishSelector:NSSelectorFromString([ticket propertyForKey:@"selector"])];
            [nsurl release];
        }
        [str release];
    } else if (error.code != 304) {
        NSLog(@"%@", error);
    }
}

-(void) handleNewDirectory:(GDataServiceTicket*) ticket entry:(GDataEntryFolderDoc*) entry error:(NSError*) error {
    if (!error) {
        NSLog(@"Directory created");
    } else {
        NSLog(@"%@", error);
    }
}

@end

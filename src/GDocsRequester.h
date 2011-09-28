//
//  GDocsRequester.h
//  synceries
//
//  Created by Anita on 05/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataDocs.h"
#import "Sheet.h"

@interface GDocsRequester : NSObject {
    GDataServiceGoogleDocs* service;
}

-(id) initWithAuthToken:(id) token;
-(void) fetchDirectoryFeedWithName:(NSString*) dirName delegate:(id) delegate selector:(SEL) selector;
-(void) createDirectoryWithName:(NSString*) dirName delegate:(id) delegate selector:(SEL) selector;
-(void) createNewSheet:(Sheet*) sheet collectionPostLink:(NSURL*) collection;

@end

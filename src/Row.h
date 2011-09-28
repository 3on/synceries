//
//  Row.h
//  synceries
//
//  Created by Anita on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataSpreadsheet.h"

@interface Row : NSObject {
    NSString* entryId;
    NSString* itemName;
    NSURL* uploadEditLink;
    NSString* eTag;
    BOOL checked;
    BOOL persisted;
}

-(id) initWithDataEntry:(GDataEntrySpreadsheetList*) entry;

@property(nonatomic, retain) NSString* entryId;
@property(nonatomic, retain) NSString* itemName;
@property(nonatomic, retain) NSURL* uploadEditLink;
@property(nonatomic, retain) NSString* eTag;

-(BOOL) checked;
-(void) setChecked:(BOOL) val;
-(BOOL) persisted;
-(void) setPersisted:(BOOL) val;

@end

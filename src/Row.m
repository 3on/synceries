//
//  Row.m
//  synceries
//
//  Created by Anita on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Row.h"


@implementation Row

@synthesize entryId;
@synthesize itemName;
@synthesize uploadEditLink;
@synthesize eTag;

-(id) initWithDataEntry:(GDataEntrySpreadsheetList*) entry {
    [self setEntryId:[entry identifier]];
    NSArray* cells = [entry customElements];
    [self setItemName:[[cells objectAtIndex:0] stringValue]];
    checked = !([cells count] < 2 || ![@"" compare:[[cells objectAtIndex:1] stringValue]]);
    [self setUploadEditLink:[[entry editLink] URL]];
    [self setETag:[entry ETag]];
    return self;
}

-(BOOL) checked {
    return checked;
}

-(void) setChecked:(BOOL) val {
    checked = val;
}

-(BOOL) persisted {
    return persisted;
}

-(void) setPersisted:(BOOL) val {
    persisted = val;
}

@end

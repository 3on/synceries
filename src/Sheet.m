//
//  Sheet.m
//  synceries
//
//  Created by Anita on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sheet.h"

@implementation Sheet
@synthesize worksheetLink;
@synthesize postLink;
@synthesize title;
@synthesize listData2;

-(id) initWithId:(NSUInteger) identifier Title:(NSString*) ttl andLink:(NSString*) link {
    [self setTitle:ttl];
    idt = identifier;
    [self setWorksheetLink:link];
    return self;
}

-(NSUInteger) id {
    return idt;
}

@end

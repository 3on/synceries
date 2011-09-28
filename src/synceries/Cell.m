//
//  Cell.m
//  synceries
//
//  Created by Jr on 05/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"


@implementation Cell

@synthesize textLabel;
@synthesize checkImage;

- (void)dealloc
{
    [checkImage release];
    [textLabel release];
    [super dealloc];
}

@end

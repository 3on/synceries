//
//  Sheet.h
//  synceries
//
//  Created by Anita on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Sheet : NSObject {
    NSUInteger idt;
    NSString* title;
    NSString* worksheetLink;
    NSMutableArray* listData2;
    NSURL* postLink;
}

@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSString* worksheetLink;
@property(nonatomic, retain) NSMutableArray* listData2;
@property(nonatomic, retain) NSURL* postLink;

-(id) initWithId:(NSUInteger) identifier Title:(NSString*) title andLink:(NSString*) link;
-(NSUInteger) id;

@end

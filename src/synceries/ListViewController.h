//
//  ListViewController.h
//  synceries
//
//  Created by Anita on 25/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sheet.h"
#import "Row.h"
#import "SQLiteManager.h"
#import "SpreadsheetsRequester.h"

@interface ListViewController : UITableViewController {
    Sheet* sheet;
    SpreadsheetsRequester* spsReq;
}

-(void) refreshAction:(id) sender;

@property(nonatomic, retain) Sheet* sheet;
@property(nonatomic, retain) SpreadsheetsRequester* spsReq;

@end

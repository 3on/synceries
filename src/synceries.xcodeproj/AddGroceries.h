//
//  AddGroceries.h
//  synceries
//
//  Created by Jr on 05/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <stdlib.h>
#import "Sheet.h"
#import "Row.h"
#import "SpreadsheetsRequester.h"

@interface AddGroceries : UIViewController {
    IBOutlet UITextField* textField;
    Sheet* sheet;
    SpreadsheetsRequester* requester;
}

@property(nonatomic, retain) Sheet* sheet;
@property(nonatomic,retain) UITextField* textField;
@property(nonatomic, assign) SpreadsheetsRequester* requester;

@end

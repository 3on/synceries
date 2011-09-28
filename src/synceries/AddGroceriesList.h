//
//  AddGroceriesList.h
//  synceries
//
//  Created by Jr on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDocsRequester.h"

@interface AddGroceriesList : UIViewController {
    
    IBOutlet UITextField *textField;
    NSMutableArray* plistData;
    GDocsRequester* gdocsReq;
    NSURL* collectionPostLink;
    UITableView* listView;
}

@property(retain,nonatomic) UITextField *textField;
@property(retain,nonatomic) NSMutableArray* plistData;

@property(assign, nonatomic) GDocsRequester* gdocsReq;
@property(assign, nonatomic) NSURL* collectionPostLink;
@property(assign, nonatomic) UITableView* listView;

@end

//
//  RootViewController.h
//  tp1
//
//  Created by shin on 10/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asihttp/ASIHTTPRequest.h"
#import "ListViewController.h"
#import "OAuthHandler.h"
#import "GDocsRequester.h"
#import "SpreadsheetsRequester.h"
#import "SQLiteManager.h"

@interface RootViewController : UITableViewController {
    NSMutableArray* plistData;
    GDocsRequester* docsReq;
    SpreadsheetsRequester* spreadsheetsReq;
    IBOutlet UITableView * listTableView;
    GTMOAuth2Authentication* authToken;
    NSURL* postLink;
}

@property (retain) IBOutlet UITableView * listTableView;

@end

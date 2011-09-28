//
//  RootViewController.m
//  tp1
//
//  Created by shin on 10/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "SettingsController.h"
#import "AddGroceriesList.h"

@implementation RootViewController

@synthesize listTableView;

- (void) refresh {
    [docsReq fetchDirectoryFeedWithName:@"synceries" delegate:self selector:@selector(directoryDataWithTicket:feed:error:)];
}

- (void) add {
    NSLog(@"Add");
    AddGroceriesList* AddGroceriesController = [[AddGroceriesList alloc] initWithNibName:nil bundle:nil];
    AddGroceriesController.plistData = plistData;
    [AddGroceriesController setCollectionPostLink:postLink];
    [AddGroceriesController setGdocsReq:docsReq];
    [AddGroceriesController setListView:listTableView];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:AddGroceriesController];
    [self presentModalViewController:navigationController animated:YES];
}

- (void) settings {
    NSLog(@"Settings");
    
    SettingsController* settings = [[SettingsController alloc] initWithNibName:nil bundle:nil];
    settings.onRevoke = @selector(onOAuthRevoke);
    settings.rootController = self;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settings];
    [self presentModalViewController:navigationController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Synceries";
    // setup navigationbar buttons
    UIImage* gear = [UIImage imageNamed:@"Gear-small.png"];
    UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithImage: gear  style:UIBarButtonItemStyleBordered target:self action:@selector(settings)]; // use initWithImage !

    [self.navigationItem setLeftBarButtonItem:settingsButton];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // toolbar buttons
    UIBarButtonItem* refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    
    self.toolbarItems = [NSArray arrayWithObjects:refresh, spacer, addButton, nil];
    
    
    
    [addButton release];
    [settingsButton release];
    [gear release];

    OAuthHandler* oauth = [[[OAuthHandler alloc] init] autorelease];
    [oauth pushAuthControllerIn:self.navigationController withDelegate:self];
    [refresh release];
    [spacer release];
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    if (error != nil) {
        // Authentication failed
        // FIXME We can do better, right?
        NSLog(@"%@", error);
        exit(1);
    } else {
        // Authentication succeeded
        authToken = [auth retain];
        docsReq = [[GDocsRequester alloc] initWithAuthToken:authToken];
        spreadsheetsReq = [[SpreadsheetsRequester alloc] initWithAuthToken:authToken];
        [docsReq fetchDirectoryFeedWithName:@"synceries" delegate:self selector:@selector(directoryDataWithTicket:feed:error:)];
    }
}

- (void) directoryDataWithTicket:(GDataServiceTicket*) ticket feed:(GDataFeedDocList*) entries error:(NSError*) error {
    if (error && error.code != 304) {
        NSLog(@"%@", error);
    } else if (error.code != 304) {
        [entries retain];
        postLink = [[entries postLink] URL];
        [postLink retain];
        SQLiteManager* manager = [[SQLiteManager alloc] init];
        [manager saveSheets:entries];
        plistData = [[manager listSheets] retain];
        [entries release];
        [manager release];
        [self.listTableView reloadData];
    }
}

-(void) onOAuthRevoke {
    [authToken release];
    [spreadsheetsReq release];
    [docsReq release];
    OAuthHandler* oauth = [[[OAuthHandler alloc] init] autorelease];
    [oauth pushAuthControllerIn:self.navigationController withDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.listTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [plistData count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (plistData) {
        Sheet* sheet = [plistData objectAtIndex:[indexPath row]];
        cell.textLabel.text = [sheet title];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    [cell setEditing:YES];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSLog(@"Data remove to co HERE");
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSLog(@"edit: %@", (NSString*)[plistData objectAtIndex:indexPath.row]);
    }   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{

}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Sheet* doc = [plistData objectAtIndex:[indexPath row]];
    ListViewController* listViewController = [[ListViewController alloc] initWithNibName:nil bundle:nil];
    listViewController.sheet = doc;
    SQLiteManager* manager = [[SQLiteManager alloc] init];
    [manager fillSheetData:doc];
    [manager release];
    listViewController.navigationItem.title = doc.title;
    [listViewController setSpsReq:spreadsheetsReq];
    [listViewController refreshAction:nil];
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:listViewController animated:YES];
    [listViewController release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [plistData release];
    plistData = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end

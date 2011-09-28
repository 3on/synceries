//
//  ListViewController.m
//  synceries
//
//  Created by Anita on 25/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"
#import "Cell.h"
#import "AddGroceries.h"


@implementation ListViewController

@synthesize sheet;
@synthesize spsReq;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) addGroceryAction:(id)sender {
    AddGroceries* AddGroceriesController = [[AddGroceries alloc] initWithNibName:nil bundle:nil];
    AddGroceriesController.sheet = sheet;
    AddGroceriesController.requester = spsReq;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:AddGroceriesController];
    [self presentModalViewController:navigationController animated:YES];
}


- (void) refreshAction:(id)sender {
    [spsReq requestDataWithWorksheetsLink:[NSURL URLWithString:[sheet worksheetLink]] callbackDelegate:self withMethod:@selector(handleData:listFeed:error:) sheet:sheet];
}

- (void) handleData:(GDataServiceTicket*) ticket listFeed:(GDataFeedSpreadsheetList*) list error:(NSError*) err {
    if (!err) {
        NSArray* entries = [list entries];
        [sheet setPostLink:[[list postLink] URL]];
        [[sheet listData2] removeAllObjects];
        [[[[SQLiteManager alloc] init] autorelease] deleteRowsForSheet:sheet];
        for (NSInteger i = 0; i < [entries count]; i++) {
            Row* row = [[Row alloc] initWithDataEntry:[entries objectAtIndex:i]];
            [sheet.listData2 addObject:row];
        }
        [[self tableView] reloadData];
    } else if (err.code != 304) {
        NSLog(@"%@", err);
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // toolbar
    UIBarButtonItem* refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction:)];
    
    UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroceryAction:)];
    
    self.toolbarItems = [NSArray arrayWithObjects:refresh, spacer, addButton, nil];
    
    [addButton release];
    [spacer release];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    SQLiteManager* manager = [[SQLiteManager alloc] init];
    [manager saveSheetData:sheet];
    [manager release];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [sheet.listData2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    Row* row = [sheet.listData2 objectAtIndex:[indexPath row]];
    NSString* key = [row itemName];
    if([row checked]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark; 
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = key;
    
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
        Row* item = [sheet.listData2 objectAtIndex:indexPath.row];
        [sheet.listData2 removeObjectAtIndex:indexPath.row];
        if ([item persisted]) {
            SQLiteManager* manager = [[[SQLiteManager alloc] init] autorelease];
            [manager deleteRow:item];
        }
        [spsReq deleteRow:item];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSLog(@"edit: %@", (NSString*)[sheet.listData2 objectAtIndex:indexPath.row]);
    }   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    id toBeMoved = [sheet.listData2 objectAtIndex:fromIndexPath.row];
    [sheet.listData2 removeObjectAtIndex:fromIndexPath.row];
    [sheet.listData2 insertObject:toBeMoved atIndex:toIndexPath.row];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // toggle check
    Row* row = [sheet.listData2 objectAtIndex:[indexPath row]];
    BOOL newValue = ![row checked];
    [row setChecked:newValue];
    
    // refresh cell drawing
    NSArray* paths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationMiddle];
    [spsReq deleteRow:row];
    [spsReq addRow:row inSheet:sheet];
}


@end

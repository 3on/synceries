//
//  AddGroceries.m
//  synceries
//
//  Created by Jr on 05/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddGroceries.h"
#import "Row.h"


@implementation AddGroceries

@synthesize textField;
@synthesize sheet;
@synthesize requester;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void)save {
    Row* new = [[Row alloc] init];
    new.itemName = textField.text;
    new.entryId = [NSString stringWithFormat:@"%@%i", new.itemName, arc4random()];
    [sheet.listData2 addObject:new];
    [new setPersisted:false];
    [requester addRow:new inSheet:sheet];
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)cancel {
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Add Grocery";
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
    
    
    // auto focus on the text Field => keyboard out
    [textField becomeFirstResponder];
    
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField addTarget:self action:@selector(save) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

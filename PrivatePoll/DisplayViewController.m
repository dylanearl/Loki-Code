//
//  DisplayViewController.m
//  PrivatePoll
//
//  Created by Aolly Li on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// Gian's Notes:
// * Need to clear password when going back to log in screen?
#import "DisplayViewController.h"
#import "DisplayCell.h"

@interface DisplayViewController ()

@end

@implementation DisplayViewController
@synthesize ResultsList;
@synthesize QuestionList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Hide the back button on the navigation bar
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.QuestionList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DisplayTableCell";
    
    DisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[DisplayCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure cells with the question and results
    cell.Question.text = [self.QuestionList objectAtIndex:indexPath.row];
    // Display results as a float
    cell.Result.text = [NSString stringWithFormat: @"%.2f", [[self.ResultsList objectAtIndex:indexPath.row] floatValue]];
    
    return cell;
}

// Once the "done" button is pressed - return to the log in screen
- (IBAction)Done:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

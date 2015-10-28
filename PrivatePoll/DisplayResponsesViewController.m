//
//  DisplayResponsesViewController.m
//
//  Created by Aolly Li
//  Modified by Gian Frez

// Gian's Notes:
// * Need to clear password when going back to log in screen?

#import "DisplayResponsesViewController.h"
#import "DisplayResponsesViewCell.h"
#import "Constants.h"

@interface DisplayResponsesViewController ()

@end

@implementation DisplayResponsesViewController
@synthesize responsesList;
@synthesize questionsList;

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
    return [self.questionsList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Store the question description
    NSString *questionDescription = [self.questionsList objectAtIndex:indexPath.row];
    
    CGSize maximumLabelSize;
    
    if (IDIOM == IPHONE) {
        maximumLabelSize = CGSizeMake(DR_IPHONE_LABEL_WIDTH, MAXFLOAT);
    } else {
        maximumLabelSize = CGSizeMake(DR_IPAD_LABEL_WIDTH, MAXFLOAT);
    }
    
    // Could use sizeToFit?
    NSLog(@"QUESTION DESCRIPTION %@", questionDescription);
    CGSize size = [questionDescription sizeWithFont:[UIFont systemFontOfSize: DR_FONT_SIZE] constrainedToSize:maximumLabelSize
                                      lineBreakMode:UILineBreakModeWordWrap];
    
    NSLog(@"HEIGHT: %f", size.height);
    
    // Could do "  CGFloat height = MAX(size.height, 44.0f);" in the future
    
    if (IDIOM == IPHONE) {
        return size.height + DR_IPHONE_MARGIN; // 100 is to accomodate for other cell subviews (the scale)
    }
    
    // Else if iPad
    return size.height + DR_IPAD_MARGIN; // At least 70 minimum height or the height + top and bottom margin of 26
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"displayResponsesCell";
    
    DisplayResponsesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[DisplayResponsesViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.question.lineBreakMode = UILineBreakModeWordWrap;
        cell.question.numberOfLines = 0;
        cell.question.font = [UIFont systemFontOfSize: DR_FONT_SIZE];
    }
    
    // Configure cells with the question and results
    cell.question.text = [self.questionsList objectAtIndex:indexPath.row];
    // Display results as a float
    cell.result.text = [NSString stringWithFormat: @"%.2f", [[self.responsesList objectAtIndex:indexPath.row] floatValue]];
    
    // Calculate the size of the question label
    CGSize maximumLabelSize;
    
    if (IDIOM == IPHONE) {
        maximumLabelSize = CGSizeMake(DR_IPHONE_LABEL_WIDTH, MAXFLOAT);
    } else {
        maximumLabelSize = CGSizeMake(DR_IPAD_LABEL_WIDTH, MAXFLOAT);
    }
    
    
    CGSize size = [cell.question.text sizeWithFont:[UIFont systemFontOfSize: DR_FONT_SIZE] constrainedToSize:maximumLabelSize
                                                lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *questionLabel = cell.question;
    UILabel *resultLabel = cell.result;
    
    if (IDIOM == IPHONE) {
        // Set the frame of the question label within the margins and of the required height and widths
        [questionLabel setFrame:CGRectMake(DR_IPHONE_MARGIN/2, DR_IPHONE_MARGIN/2, DR_IPHONE_LABEL_WIDTH, size.height)];
        
        // Set the frame of the results label within the margins and of the required height and widths
        [resultLabel setFrame: CGRectMake(cell.frame.size.width - DR_IPHONE_MARGIN/2 - resultLabel.frame.size.width, DR_IPHONE_MARGIN/2, resultLabel.frame.size.width, resultLabel.frame.size.height)];
    } else {
        [questionLabel setFrame:CGRectMake(DR_IPAD_MARGIN/2, DR_IPAD_MARGIN/2, DR_IPAD_LABEL_WIDTH, size.height)];
        [resultLabel setFrame: CGRectMake(cell.frame.size.width - DR_IPAD_MARGIN/2 - resultLabel.frame.size.width, DR_IPAD_MARGIN/2, resultLabel.frame.size.width, resultLabel.frame.size.height)];

    }
    
    return cell;
}

// Once the "done" button is pressed - return to the log in screen
- (IBAction)done:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

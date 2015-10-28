//
//  SelectSurveyViewController.m
//
//  Created by Aolly Li
//  Modified by Gian Frez

// Gian's Notes:
// * Improve tableView

#import "SelectSurveyViewController.h"
#import "SelectSurveyViewCell.h"
#import "SurveyViewController.h"
#import "SurveyDescriptionViewController.h"
#import "ServerInterface.h"
#import "Constants.h"

@interface SelectSurveyViewController ()

@end

@implementation SelectSurveyViewController

@synthesize storedIndexPath;
@synthesize userInfo;
@synthesize surveyList;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // Each row is a survey
    return [self.surveyList count];
}

// Display a new table cell for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectSurveyTableCell";
    
    // Either reuse or create a new cell
    SelectSurveyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[SelectSurveyViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *survey = [self.surveyList objectAtIndex: indexPath.row];
    // Store the attributes for a survey returned from the server
    // Tags uniquely identify each interactive element in the cell (including the cell) so that information can be retreived to be used elsewhere
    cell.surveyName.text = [survey objectForKey:@"surveyName"];
    
    // Set tags to uniquely identify the cell and its objects
    cell.tag = 10*indexPath.row;
    cell.privacyLevel.tag = 10*indexPath.row + 1;
    cell.surveyRequestor.text = @"";
    cell.surveyReward.text = @"";
    
    //If on an iPad - display the survey description
    if ( IDIOM == IPAD ) {
        cell.surveyDescription.text = [survey objectForKey:@"surveyDescription"];
    }
    
    return cell;
}

// Enter when a row has been selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    // Store the index path for future use
    self.storedIndexPath = indexPath;
    
    NSLog(@"INDEXPATH.row: %d", storedIndexPath.row);
    
    UITableViewCell *cell = (UITableViewCell*)[self.tableView viewWithTag:10*indexPath.row];
    
    UISegmentedControl *privacy = (UISegmentedControl*)[cell viewWithTag:10*indexPath.row + 1];
    
    NSInteger privacyLevel = privacy.selectedSegmentIndex;
    // If privacy level is not "none", segue to the survey view
    if (privacyLevel != 0) {
        // Visually deselect the row that has been chosen
        [self.tableView deselectRowAtIndexPath:storedIndexPath animated:YES];
        [self performSegueWithIdentifier:@"CompleteSurvey" sender:self];
    }
    // If privacy level is "none", display an alert
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Privacy"
                                                            message:@"Are you sure you want to proceed with no privacy?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        [alertView show];  
    }   
    
    
}

// Enter this method after the privacy level alert is animated
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // If "No" selected, clear the survey chosen and go back to SurveySelect view
    if (buttonIndex == 0) {
        [self.tableView deselectRowAtIndexPath:storedIndexPath animated:YES];
    } else if (buttonIndex == 1) // Otherwise if "yes", user wants to proceeed so segue to the survey view
    {
        [self.tableView deselectRowAtIndexPath:storedIndexPath animated:YES];
        [self performSegueWithIdentifier:@"CompleteSurvey" sender:self];
    }
}

- (IBAction)infoBtn:(id)sender {
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:(UITableViewCell *)
                                [[sender superview] superview]];
    // Find out the index of the selected row of the info button selected (for iPhone)
    self.storedIndexPath = myIndexPath;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Prepare for segue to the survey view
    if ([[segue identifier] isEqualToString:@"CompleteSurvey"]) {
        [self.tableView deselectRowAtIndexPath:storedIndexPath animated:YES];
        SurveyViewController *surveyViewController = [segue destinationViewController];  
        
        // Temporarily store the survey data to be sent to the survey view
        NSDictionary *survey = [self.surveyList objectAtIndex:storedIndexPath.row];
        
        // Assign the survey name as the title of the navigation bar for the survey view
        UITabBarController *surveyViewTabBar = [segue destinationViewController];
        surveyViewTabBar.navigationItem.title = [survey objectForKey:@"surveyName"];
        
        // Retrieve the cell and privacy levels
        UITableViewCell *cell = (UITableViewCell*)[self.tableView viewWithTag:10*storedIndexPath.row];
        UISegmentedControl *privacy = (UISegmentedControl*)[cell viewWithTag:10*storedIndexPath.row + 1];
        NSInteger privacyLevel = privacy.selectedSegmentIndex+1;
        NSLog(@"ROW: %d, USERSETPRIVACY: %d", storedIndexPath.row, privacyLevel);
        
        // Send privacy level to the server
        ServerInterface *interface = [[ServerInterface alloc] init];
        BOOL error = [interface setPrivacy:[NSString stringWithFormat: @"%d", [[survey objectForKey:@"surveyID"] integerValue]] :[self.userInfo objectAtIndex:0] :[self.userInfo objectAtIndex:1] :[NSString stringWithFormat: @"%d", privacyLevel]];
        NSLog(@"SET PRIVACY STATUS: %d", error);
        
        // Send surveyViewController survey information
        surveyViewController.privacy = privacyLevel;
        surveyViewController.userInfo = self.userInfo;
        surveyViewController.sessionInfo = [[NSArray alloc] initWithObjects:[survey objectForKey:@"surveyID"], [survey objectForKey:@"session_id"], nil];
        
    }
    
    // Prepare for a segue to the survey description (iPhone only - occurs when "i" button pressed)
    else if ([[segue identifier] isEqualToString:@"surveyDescription"]) {
        NSDictionary *survey = [self.surveyList objectAtIndex:storedIndexPath.row];
        
        SurveyDescriptionViewController *surveyDescriptionViewController = [segue destinationViewController];
        surveyDescriptionViewController.surveyDescriptions = [[NSArray alloc] initWithObjects:[survey objectForKey:@"surveyDescription"], [survey objectForKey:@"surveyName"], nil];
    }
}
@end

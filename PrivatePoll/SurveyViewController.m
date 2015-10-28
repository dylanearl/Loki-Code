//
//  SurveyViewController.m
//
//  Created by Aolly Li
//  Modified by Gian Frez


// Gian's Notes:
// * Go back to hide privacy to understand it once vijay's paper received
// * Might need to fix up alpha values for ratings - buggy?
// * Fix up cell enabled  and ratingChange- redundancy with cellForRowAtIndexPath
// * Fix up slider so it works on a tap?
// * Remove send method?
// * Do something if error happens
// * No responses = dont send anything?
// * Might need to add a way of sending what the rating labels should be?

#import "SurveyViewController.h"
#import "SurveyViewCell.h"
#import "ServerInterface.h"
#import "DisplayResponsesViewController.h"
#import "Reachability.h"
#import "Constants.h"

@interface SurveyViewController ()

@end

@implementation SurveyViewController
@synthesize userInfo;
@synthesize privacy;
@synthesize questionResponse, questionEnabled;
@synthesize surveyQuestions;
@synthesize noSendErrors;
@synthesize sessionInfo;

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
    
    // Initialise variables
    self.noSendErrors = TRUE;
    
    // Estalish connection with Server
    Reachability* reachability;
    reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    // Display alert if there is no internet connection
    if(remoteHostStatus == NotReachable)  {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No internet connection"
                                                            message:@"Please connect to a data network."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil ];
        [alertView show];
    }
    else { // Otherwise, retrieve the survey questions from the server
    
        ServerInterface *serverInterface = [[ServerInterface alloc] init];
    
        NSLog(@"SESSION ID: %d", [[self.sessionInfo objectAtIndex:1] integerValue]);
    
        // Store the survey questions (for the provided surveyID) from the server into an array
        self.surveyQuestions = [serverInterface surveyQuestions:[NSString stringWithFormat: @"%d", [[self.sessionInfo objectAtIndex:0] integerValue]]];
    }
    
    // Initialise the ratings to 3 - neutral
    self.questionResponse = [[NSMutableArray alloc]initWithObjects: @"3", nil];
    
    // Initialise whether a question is enabled
    self.questionEnabled = [[NSMutableArray alloc]initWithObjects: @"0", nil];
    
    // Count amount of survey questions
    NSInteger questionsCount = [self.surveyQuestions count];
    // For ever survey question, add an initial rating of 3 (netural) and disable question
    for (int i = 1; i < questionsCount; i++) {
        [self.questionResponse addObject:@"3"];
        [self.questionEnabled addObject:@"0"];
    }

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.surveyQuestions count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Read the data for the current index/row
    NSDictionary *surveyQuestion = [self.surveyQuestions objectAtIndex:indexPath.row];
    // Store the question description
    NSString *questionDescription = [surveyQuestion objectForKey:@"question"];
    
    CGSize maximumLabelSize;
    
    if (IDIOM == IPHONE) {
        maximumLabelSize = CGSizeMake(SV_IPHONE_LABEL_WIDTH, MAXFLOAT);
    } else {
        maximumLabelSize = CGSizeMake(SV_IPAD_LABEL_WIDTH, MAXFLOAT);
    }
    
    // Could use sizeToFit?
    NSLog(@"QUESTION DESCRIPTION %@", questionDescription);
    CGSize size = [questionDescription sizeWithFont:[UIFont systemFontOfSize: SV_FONT_SIZE] constrainedToSize:maximumLabelSize
                       lineBreakMode:UILineBreakModeWordWrap];
    
    NSLog(@"HEIGHT: %f", size.height);
    
    // Could do "  CGFloat height = MAX(size.height, 44.0f);" in the future
    
    if (IDIOM == IPHONE) {
        return size.height + SV_IPHONE_MARGIN; // 100 is to accomodate for other cell subviews (the scale)
    }
    
    // Else if iPad
    return MAX(70, size.height + SV_IPAD_MARGIN); // At least 70 minimum height or the height + top and bottom margin of 26
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SurveyTableCell";
    
    // Either create a new cell or reuse an existing cell
    SurveyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[SurveyViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.questionDescription.lineBreakMode = UILineBreakModeWordWrap;
        cell.questionDescription.numberOfLines = 0;
        cell.questionDescription.font = [UIFont systemFontOfSize: SV_FONT_SIZE];
    }
    

    
    // Read the data for the current index/row
    NSDictionary *oneSurveyQuestion = [self.surveyQuestions objectAtIndex:indexPath.row];
    
    // Store the question description
    cell.questionDescription.text = [oneSurveyQuestion objectForKey:@"question"];
    
    // Calculate the size of the question label
    CGSize maximumLabelSize;
    
    if (IDIOM == IPHONE) {
        maximumLabelSize = CGSizeMake(SV_IPHONE_LABEL_WIDTH, MAXFLOAT);
    } else {
        maximumLabelSize = CGSizeMake(SV_IPAD_LABEL_WIDTH, MAXFLOAT);
    }
    
    CGSize size = [cell.questionDescription.text sizeWithFont:[UIFont systemFontOfSize: SV_FONT_SIZE] constrainedToSize:maximumLabelSize
                                      lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *questionLabel = cell.questionDescription;
    
    // Set size of label frame
    CGRect newFrame = questionLabel.frame;
    // Maybe assign the width and origin if required?
    newFrame.size.height = size.height;
    questionLabel.frame = newFrame;
    
    // Shift the rating scale to below the new question label
    if (IDIOM == IPHONE) {        
        cell.optionOne.center = CGPointMake(cell.optionOne.center.x, questionLabel.center.y + questionLabel.frame.size.height/2 + 30);
        cell.optionTwo.center = CGPointMake(cell.optionTwo.center.x, questionLabel.center.y + questionLabel.frame.size.height/2 + 30);
        cell.optionThree.center = CGPointMake(cell.optionThree.center.x, questionLabel.center.y + questionLabel.frame.size.height/2 + 30);
        cell.optionFour.center = CGPointMake(cell.optionFour.center.x, questionLabel.center.y + questionLabel.frame.size.height/2 + 30);
        cell.optionFive.center = CGPointMake(cell.optionFive.center.x, questionLabel.center.y + questionLabel.frame.size.height/2 + 30);
        cell.userRating.center = CGPointMake(cell.userRating.center.x, questionLabel.center.y + questionLabel.frame.size.height/2 + 60);
    }
    
    
    // Specify tags for the cell objects so that they can be easily accessed later
    cell.tag = 100*indexPath.row;

    cell.optionOne.tag = 100*indexPath.row + 1;
    cell.optionTwo.tag = 100*indexPath.row + 2;
    cell.optionThree.tag = 100*indexPath.row + 3;
    cell.optionFour.tag = 100*indexPath.row + 4;
    cell.optionFive.tag = 100*indexPath.row + 5;
    cell.userRating.tag = 100*indexPath.row + 6;
    //cell.checkbox.tag = 111;//100*indexPath.row + 7;
    
    // Initialise the cells with the slider disabled
    cell.userRating.enabled = NO;
    // Assign the rating value to be default at 3 (neutral)
    cell.userRating.value = 3;
    
    // Initialise the rating options to be greyed out (alpha = 0.5)
    cell.optionOne.alpha = 0.5;
    cell.optionTwo.alpha = 0.5;
    cell.optionThree.alpha = 0.5;
    cell.optionFour.alpha = 0.5;
    cell.optionFive.alpha = 0.5;
    
    // Initialise the check box to be an unselected check box
    UIImage *unchecked = [UIImage imageNamed:@"unchecked.png"];
    [cell.checkbox setImage:unchecked forState:UIControlStateNormal];
    
    return cell;
}

// Send the survey responses to the server
- (IBAction)sendResponses:(id)sender {
    NSInteger totalQuestionsCount = [self.surveyQuestions count];
    NSInteger answeredQuestionsCount = 0;
    
    // Count the number of answered questions
    for (int i = 0; i < totalQuestionsCount; i++) {
        if ([[self.questionEnabled objectAtIndex:i] integerValue] == 1) {
            answeredQuestionsCount++;
        }
    }
    
    NSLog(@"AMOUNT OF QUESTIONS ANSWERED = %d", answeredQuestionsCount);
    
    // Display an alert if no questions have been answered
    if (answeredQuestionsCount == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Data"
                                                            message:@"You have not answered any of the questions. Do you still want to send this?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        [alertView show];
    } else {
        Reachability* reachability;
        reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
        
        // Display alert if network not available
        if(remoteHostStatus == NotReachable)  {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No internet connection"
                                                                message:@"Please connect to a data network."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:nil ];
            [alertView show];
            
            // Reset flags
            self.noSendErrors = FALSE;
        } else {
            int i = 0;
            while (i < totalQuestionsCount && self.noSendErrors) {
                // If a question is enabled, send the response
                if ([[self.questionEnabled objectAtIndex:i] integerValue] == 1) {
                    ServerInterface *serverInterface = [[ServerInterface alloc] init];
                    NSDictionary *surveyQuestion = [self.surveyQuestions objectAtIndex:i];
                    
                    // Store the original response
                    NSInteger originalResponse = [[self.questionResponse objectAtIndex:i] integerValue];
                    
                    // Calculate noise (dependent on privacy levels)
                    double noise = [self hideRatings:privacy];

                    // Add noise to the original response and store this value
                    double noiseyResponse = originalResponse + noise;
                    [self.questionResponse replaceObjectAtIndex:i withObject:[NSString stringWithFormat: @"%f", noiseyResponse]];
                    
                    // Send the noise response to the server
                    self.noSendErrors = [serverInterface sendSurveyData:[NSString stringWithFormat: @"%d", [[surveyQuestion objectForKey:@"id"] integerValue]] :[NSString stringWithFormat: @"%f", noiseyResponse] :[userInfo objectAtIndex:0] :[userInfo objectAtIndex:1]];
                }
                i++;
            }
        }
        
        // Display an alert if an error occured
        if (!self.noSendErrors) {     
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"There was an error submitting your results."
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil ];
            [alertView show];
            
            // Reset
            self.noSendErrors = TRUE;
        }  else {
            [self performSegueWithIdentifier:@"DisplayResponses" sender:self];
        }
    }
    

}


// This method is entered whenever an alert view is displayed
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // If "yes" pressed when prompting user with an alert of whether they want to send a survey with unanswered questions, segue to the next screen (there is nothing to send)
    if (buttonIndex == 1)
    {
        [self performSegueWithIdentifier:@"DisplayResponses" sender:self];
    }
}

// Enables and disables the rating slider (greys out when disabled (alpha = 0.5))
- (IBAction)cellEnabled:(id)sender {
    
    // Retrieve the indexPath selected
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:(UITableViewCell *)
                                [[sender superview] superview]];

    // Retrieve the cell and its elements
    UITableViewCell *cell = (UITableViewCell*)[self.tableView viewWithTag:100*myIndexPath.row];
    UILabel *label1 = (UILabel*)[cell viewWithTag:100*myIndexPath.row + 1];
    UILabel *label2 = (UILabel*)[cell viewWithTag:100*myIndexPath.row + 2];
    UILabel *label3 = (UILabel*)[cell viewWithTag:100*myIndexPath.row + 3];
    UILabel *label4 = (UILabel*)[cell viewWithTag:100*myIndexPath.row + 4];
    UILabel *label5 = (UILabel*)[cell viewWithTag:100*myIndexPath.row + 5];
    UISlider *slider = (UISlider*)[cell viewWithTag:100*myIndexPath.row + 6];

    // Enable sliders and labels when question is checked
    if ([[self.questionEnabled objectAtIndex:myIndexPath.row] integerValue] == 0)
    {
        // Display a checked image
        UIImage *checked = [UIImage imageNamed:@"checked.png"];
        [sender setImage:checked forState:UIControlStateNormal];
        
        // Enable slider and make the label where the slider is at visible
        slider.enabled = YES;
        if (slider.value == 1) {
            [label1 setAlpha:1];
        } else if (slider.value == 2) {
            [label2 setAlpha:1];
        } else if (slider.value == 3) {
            [label3 setAlpha:1];
        } else if (slider.value == 4) {
            [label4 setAlpha:1];
        } else {
            [label5 setAlpha:1];
        }
        
        // Signify that the question is now enabled
        [self.questionEnabled replaceObjectAtIndex:myIndexPath.row withObject:@"1"];
    }
    else
    { // Otherwise disable slider and labels when question is unchecked
        UIImage *unchecked = [UIImage imageNamed:@"unchecked.png"];
        [sender setImage:unchecked forState:UIControlStateNormal];
        
        // Disable the slider and make the labels grey
        slider.enabled = NO;
        // Set the slider to default at 3
        slider.value = 3;
        [label1 setAlpha:0.5];
        [label2 setAlpha:0.5];
        [label3 setAlpha:0.5];
        [label4 setAlpha:0.5];
        [label5 setAlpha:0.5];
        
        // Signify that the question is now disabled
        [self.questionEnabled replaceObjectAtIndex:myIndexPath.row withObject:@"0"];
    }
}

// Sets up the visuals/animations for when the slider is moved (rating changes)
- (IBAction)ratingChanged:(id)sender {
    // Retrieve the indexPath selected
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:(UITableViewCell *)
                                [[sender superview] superview]];
    
    UISlider *slider = (UISlider *)sender;
    
    // Retreive the cell and its elements
    UITableViewCell *cell = (UITableViewCell*)[self.tableView viewWithTag:100*myIndexPath.row];
    UILabel *label1 = (UILabel*)[cell viewWithTag:100*myIndexPath.row + 1];
    UILabel *label2 = (UILabel*)[cell viewWithTag:100*myIndexPath.row + 2];
    UILabel *label3 = (UILabel*)[cell viewWithTag:100*myIndexPath.row + 3];
    UILabel *label4 = (UILabel*)[cell viewWithTag:100*myIndexPath.row + 4];
    UILabel *label5 = (UILabel*)[cell viewWithTag:100*myIndexPath.row + 5];
    
    // Configure slider threshold values and display the selected label when the slider is within range
    if (slider.value < 1.5) {
        [slider setValue:1 animated:NO];
        [label1 setAlpha:1];
        [label2 setAlpha:0.5];      
    } else if (slider.value < 2.5) {
        [slider setValue:2 animated:NO];
        [label1 setAlpha:0.5];
        [label2 setAlpha:1];
        [label3 setAlpha:0.5];
    } else if (slider.value < 3.5) {
        [slider setValue:3 animated:NO];
        [label2 setAlpha:0.5];
        [label3 setAlpha:1];
        [label4 setAlpha:0.5];
    } else if (slider.value < 4.5) {
        [slider setValue:4 animated:NO];
        [label3 setAlpha:0.5];
        [label4 setAlpha:1];
        [label5 setAlpha:0.5];
    } else {
        [slider setValue:5 animated:NO];
        [label4 setAlpha:0.5];
        [label5 setAlpha:1];
    }
    
    // Save slider value to "ratings"
    NSInteger userRating = slider.value;
    [self.questionResponse replaceObjectAtIndex:myIndexPath.row withObject:[NSString stringWithFormat: @"%d", userRating]];
    
}

// Implement privacy protection - add noise (dependent on privacy level)
- (double) hideRatings:(int)privacyLevel {
    double uniformRv_1, uniformRv_2, radiusSquare, gaussianRv, x;
    
    do {
        // Generate random doubles
        uniformRv_1 = drand48();
        uniformRv_2 = drand48();
        
        uniformRv_1 = 2*uniformRv_1-1;
        uniformRv_2 = 2*uniformRv_2-1;
        
        radiusSquare = uniformRv_1*uniformRv_1 + uniformRv_2*uniformRv_2;
    } while (radiusSquare >= 1 || radiusSquare == 0);

    gaussianRv = sqrt(-2 * log(radiusSquare)/radiusSquare);
    x = gaussianRv*uniformRv_1;

    // Adjust standard deviation according to privacy level (the above code is for mean = 0 and standard deviation = 1 so multiply by required standard deviation)
    switch (privacyLevel) {
        case PRIVACY_NONE: return 0.0;
        case PRIVACY_LOW: return (x*1.0);
        case PRIVACY_MEDIUM: return (x*2.0);
        case PRIVACY_HIGH: return (x*4.0);
    }
    
    return 0;
}

// Segue to Display Results view after sending results
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DisplayResponses"]) {
        DisplayResponsesViewController *displayResponsesViewController = [segue destinationViewController];  
        
        // Count how many questions have been answered
        NSInteger totalQuestionsCount = [self.surveyQuestions count];
        NSInteger answeredQuestionsCount = 0;
        for (int i = 0; i < totalQuestionsCount; i++) {
            if ([[self.questionEnabled objectAtIndex:i] integerValue] == 1) {
                answeredQuestionsCount++;
            }
        }
        
        displayResponsesViewController.questionsList = [[NSMutableArray alloc] initWithCapacity:answeredQuestionsCount];
        displayResponsesViewController.responsesList = [[NSMutableArray alloc] initWithCapacity:answeredQuestionsCount];
        
        // Only display the questions that have been answered
        for (int i = 0; i < totalQuestionsCount; i++) {
            if ([[self.questionEnabled objectAtIndex:i] integerValue] == 1) {
                NSDictionary *surveyQuestion = [self.surveyQuestions objectAtIndex:i];
                // Send question
                [displayResponsesViewController.questionsList addObject:[surveyQuestion objectForKey:@"question"]];
                // Send question response
                [displayResponsesViewController.responsesList addObject:[NSString stringWithFormat: @"%f", [[self.questionResponse objectAtIndex:i] floatValue]]];
            }
        }
        
    }
}

@end

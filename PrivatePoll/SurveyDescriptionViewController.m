//
//  SurveyDescriptionViewController.m
//
//  Created by Aolly Li
//  Modified by Gian Frez


#import "SurveyDescriptionViewController.h"

@interface SurveyDescriptionViewController ()

@end

@implementation SurveyDescriptionViewController
@synthesize surveyDescription;
@synthesize surveyName;
@synthesize surveyDescriptions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Display the Description Information
    
    self.surveyDescription.text = [self.surveyDescriptions objectAtIndex:0];
    self.surveyName.text = [self.surveyDescriptions objectAtIndex:1];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.surveyDescription = nil;
    self.surveyName = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

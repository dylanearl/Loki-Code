//
//  LoginViewController.m
//
//  Created by Aolly Li
//  Modified by Gian Frez

// Gian's Notes:
// * Need to support more than just portrait orientation?
// * Need to create a password error alert

#import "LoginViewController.h"
#import "SelectSurveyViewController.h"
#import "ServerInterface.h"
#import "Reachability.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userName, userPassword;
@synthesize surveyList;

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.userName = nil;
    self.userPassword = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only supported orientiation is portrait - might need to change down the track?
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Enter this method when user presses return when in password box or hits "login"
- (IBAction)loginUser:(id)sender {
    
    // Create a ServerInterface instance in order to communicate with the server
    ServerInterface *serverInterface = [[ServerInterface alloc] init];
    
    NSString* username = self.userName.text;
    NSString* password = self.userPassword.text;
    
    // Display alert if invalid username and/or password
    if ((username == NULL || username.length == 0) || (password == NULL || password.length == 0)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                            message:@"No Password or User ID entered"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil ];
        [alertView show]; 
    } else { // Otherwise, send information to the server
        // Set up network connection
        Reachability* reachability;
        reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
        
        // Display alert if no internet connection
        if(remoteHostStatus == NotReachable)  {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No internet connection"
                                                                message:@"Please connect to a data network."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:nil ];
            [alertView show];
        }
        else {
            // Retreive the list of surveys from the server given the entered username/password
            self.surveyList = [serverInterface surveyList:username:password];
        
            // Display alert if no surveys are available
            if (self.surveyList == NULL || self.surveyList.count == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"No surveys avaliable"
                                                               delegate:self
                                                      cancelButtonTitle:@"Okay"
                                                      otherButtonTitles:nil ];
                [alertView show]; 
            } /*else if (PASSWORD ERROR) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                    message:@"Check User ID & Password."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:nil ];
                [alertView show];
                
            }*/
            else {
                // If there are no errors, segue to the next view - select survey
                [self performSegueWithIdentifier:@"SelectSurvey" sender:self];
            }
        }
    }

}

// Hide the keyboard when the user presses the return key
- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

// Hide the keyboard when the background is touched (when entering username or password)
- (IBAction)backgroundTouched:(id)sender
{
    [self.userName resignFirstResponder];
    [self.userPassword resignFirstResponder];
}

// Perform tasks before SelectSurvey segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SelectSurvey"]) {
        // Create an instance of the destination view controller - SelectSurveyViewController
        SelectSurveyViewController *selectSurveyViewController = [segue destinationViewController];
        // Send a userInfo array which contains the userName and userPassword entered by user in the LoginView
        selectSurveyViewController.userInfo = [[NSArray alloc] initWithObjects:self.userName.text, self.userPassword.text,nil];
        NSLog(@"USER INFO SENT TO SELECTSURVEYVIEWCONTROLLER FROM LOGINVIEWCONTROLLER:%@", selectSurveyViewController.userInfo);
        // Send survey list
        selectSurveyViewController.surveyList = self.surveyList;
        NSLog(@"SURVEY LIST SENT TO SELECTSURVEYVIEWCONTROLLER FROM LOGINVIEWCONTROLLER:%@", self.surveyList);
    }
}
@end

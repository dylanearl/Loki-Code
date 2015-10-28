//
//  Register.m
//
//  Created by Aolly Li
//  Modified by Gian Frez


// Gian's Notes:
// * Validation is currently just format, rather than actual content - may need to improve this
// * Need to do something when registration information to the server fails
// * Need to do something with server error code after sending the registration


#import "Register.h"
#import "ServerInterface.h"
#import "Reachability.h"
#import "SelectSurveyViewController.h"
#import "Constants.h"

@interface Register ()

@end

@implementation Register
@synthesize userName, userFirstName, userLastName, userAge, userCountry, userPostcode, userOrganisation, userEmail, userPassword;
@synthesize userGenderSegment;
@synthesize userAgeSegment;

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
    
    // http://stackoverflow.com/questions/2321038/dismiss-keyboard-by-touching-background-of-uitableview
    // Detect a single tap gesture for hiding the keyboard when the background of UITableView is touched
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    // Allow cell selection to still work
    gestureRecognizer.cancelsTouchesInView = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.   
    self.userName = nil;
    self.userFirstName = nil;
    self.userLastName = nil;
    self.userAge = nil;
    self.userCountry = nil;
    self.userPostcode = nil;
    self.userOrganisation = nil;
    self.userEmail = nil;
    self.userPassword = nil;
    self.userGenderSegment = nil;
    self.userAgeSegment = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Set the flags and check marks for each field (set by the valid methods below)
// otherCheckIsValid is for performing an extra check to see if the required field is a valid number or email
- (void)setCheckAndFlag:(NSString *)field:(int)row:(BOOL *)isValid:(BOOL)otherIsValidCheck {
    if ((field == NULL || field.length == 0) || !otherIsValidCheck) {
        [self setCheckMark:row:NO];
        *isValid = 0;
    } else {
        [self setCheckMark:row:YES];
        *isValid = 1;
    }
}

// The following "Valid" methods determine if the required information is entered correctly. SetCheck displays a checkmark to user to indicate valid information. Flags are used for error checking.
- (IBAction)checkValidUserName:(id)sender {
     NSString* string = self.userName.text;
    [self setCheckAndFlag:string:0:&isValidUsername:TRUE];
}

- (IBAction)checkValidFirstName:(id)sender {
    NSString* string = self.userFirstName.text;
    [self setCheckAndFlag:string:1:&isValidFirstName:TRUE];
}

- (IBAction)checkValidLastName:(id)sender {
    NSString* string = self.userLastName.text;
    [self setCheckAndFlag:string:2:&isValidLastName:TRUE];
}

- (IBAction)checkValidEmail:(id)sender {
    NSString* string = self.userEmail.text;
    [self setCheckAndFlag:string:3:&isValidEmail:[self NSStringIsValidEmail:string]];
}

// For iPhone age text field only
- (IBAction)checkValidAge:(id)sender {
    NSString* string = self.userAge.text;
    [self setCheckAndFlag:string:5:&isValidAge:[self NSStringIsValidNumber:string]];
        
    // Convert text to an integer
    NSInteger enteredUserAge = [self.userAge.text integerValue];
    NSLog(@"IPHONE USER'S AGE: %d", enteredUserAge);
    
    if (enteredUserAge >= 12 && enteredUserAge <=25) {
        self.userAge.text = @"12 - 25";
        ageSegment = @"1";
    } else if (enteredUserAge >= 26 && enteredUserAge <=40) {
        self.userAge.text = @"26 - 40";
        ageSegment = @"2";
    } else if (enteredUserAge >= 41 && enteredUserAge <=55) {
        self.userAge.text = @"41 - 55";
        ageSegment = @"3";
    } else if (enteredUserAge >= 56 && enteredUserAge <=75) {
        self.userAge.text = @"56 - 75";
        ageSegment = @"4";
    } else if (enteredUserAge >= 76 && enteredUserAge <=110) {
        self.userAge.text = @"76+";
        ageSegment = @"5";
    } else { // If not in range, age is invalid
        [self setCheckMark:5:NO];
        isValidAge = 0;
        self.userAge.text = @"Invalid";
    }
}

- (IBAction)checkValidCountry:(id)sender {
    NSString* string = self.userCountry.text;
    [self setCheckAndFlag:string:6:&isValidCountry:TRUE];
}

- (IBAction)checkValidPostcode:(id)sender {
    NSString* string = self.userPostcode.text;
    [self setCheckAndFlag:string:7:&isValidPostcode:[self NSStringIsValidNumber:string]];
}

- (IBAction)checkValidOrganisation:(id)sender {    
    NSString* string = self.userOrganisation.text;
    [self setCheckAndFlag:string:8:&isValidOrganisation:TRUE];
}

- (IBAction)checkValidPassword:(id)sender {    
    NSString* string = self.userPassword.text;
    [self setCheckAndFlag:string:9:&isValidPassword:TRUE];
}

- (IBAction)registerUser:(id)sender {
    // Determine which gender segment has been selected 
    NSInteger genderSegmentIndex = self.userGenderSegment.selectedSegmentIndex;
    NSString* gender = @"";
    
    if (genderSegmentIndex == 0) {
       gender = @"F";
    } else {
        gender = @"M";
    }
    
    BOOL isValid = 0;
    
    // If iPad is being used, age is a segemented control, therefore determine the age bracket selected
    // flag is used to determine if all fields are valid (for iPhone, need to check the entered age)
    if (IDIOM == IPAD) {
        ageSegment = [NSString stringWithFormat: @"%d", self.userAgeSegment.selectedSegmentIndex];
        //isValid = isValidUsername && isValidFirstName && isValidLastName && isValidEmail && isValidCountry && isValidPostcode && isValidOrganisation && isValidPassword;
        
        isValid = isValidUsername && isValidEmail && isValidPassword;
        
    } else { // for iPhone
        isValid = isValidUsername && isValidFirstName && isValidLastName && isValidEmail && isValidAge && isValidCountry && isValidPostcode && isValidOrganisation && isValidPassword;
    }
    
    // If all fields are valid, send deatils to the server
    if (isValid) {
        Reachability* reachability;
        reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
        
        // Display alert if data network not available
        if(remoteHostStatus == NotReachable)  {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No internet connection"
                                                                message:@"Please connect to a data network."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:nil ];
            [alertView show];
        } else { // Otherwise, send register information
            
            ServerInterface *serverInterface = [[ServerInterface alloc] init];

            NSString *dataAsString = @"{";
            dataAsString = [dataAsString stringByAppendingString:@"\"username\": \""];
            dataAsString = [dataAsString stringByAppendingString:self.userName.text];
            
            dataAsString = [dataAsString stringByAppendingString:@"\", \"firstname\": \""];
            dataAsString = [dataAsString stringByAppendingString:self.userFirstName.text];
            
            dataAsString = [dataAsString stringByAppendingString:@"\", \"surname\": \""];
            dataAsString = [dataAsString stringByAppendingString:self.userLastName.text];
            
            dataAsString = [dataAsString stringByAppendingString:@"\", \"organisation\": \""];
            dataAsString = [dataAsString stringByAppendingString:self.userOrganisation.text];
            
            dataAsString = [dataAsString stringByAppendingString:@"\", \"email\": \""];
            dataAsString = [dataAsString stringByAppendingString:self.userEmail.text];
            
            dataAsString = [dataAsString stringByAppendingString:@"\", \"country\": \""];
            dataAsString = [dataAsString stringByAppendingString:self.userCountry.text];
            
            dataAsString = [dataAsString stringByAppendingString:@"\", \"postcode\": \""];
            dataAsString = [dataAsString stringByAppendingString:self.userPostcode.text];
            
            dataAsString = [dataAsString stringByAppendingString:@"\", \"password\": \""];
            dataAsString = [dataAsString stringByAppendingString:self.userPassword.text];
            
            NSLog(@"REGISTERED AGE SEGMENT: %@", ageSegment);
            dataAsString = [dataAsString stringByAppendingString:@"\", \"age_group\": "];
            dataAsString = [dataAsString stringByAppendingString:ageSegment];
            
            dataAsString = [dataAsString stringByAppendingString:@", \"gender\": \""];
            dataAsString = [dataAsString stringByAppendingString:gender];
            dataAsString = [dataAsString stringByAppendingString:@"\"}"];
            
            NSLog(@"URL SENT FROM REGISTRATION PAGE:%@", dataAsString);
            BOOL Errorcode = NO;
            
            Errorcode = [serverInterface registerUser:dataAsString];
            
            // If no errors, go back to log in view (root view)
            if (Errorcode == YES) {
                // success
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                // fail
                // what do we do here? Display alert? Refill form?
            }
        }
    }
    
}

// Hide keyboard when user taps out of a table view cell
- (void) hideKeyboard {
    [self.userEmail resignFirstResponder];
    [self.userOrganisation resignFirstResponder];
    [self.userName resignFirstResponder];
    [self.userFirstName resignFirstResponder];
    [self.userLastName resignFirstResponder];
    [self.userCountry resignFirstResponder];
    [self.userPassword resignFirstResponder];
    [self.userPostcode resignFirstResponder];
}


- (void)setCheckMark:(NSInteger)row:(BOOL)checked
{
    // iPad has two sections - section 0 for UNSW logo, section 1 for user information
    NSInteger section = 1;
    
    // iPhone's register table view does not have the UNSW logo - section 0 is for user information
    if (IDIOM == IPHONE ) {
        section = 0;
    }
    
    // Set the check mark on or off if the entered field is valid
    NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:myIndexPath];
    if (checked) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

// Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
// Check to see if the email format is valid
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}

// Check to see if a number is valid (based on NSStringIsValidEmail method)
-(BOOL) NSStringIsValidNumber:(NSString *)checkString
{
    NSString *filterString = @"[0-9]*";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filterString];
    
    return [numberTest evaluateWithObject:checkString];
}

@end

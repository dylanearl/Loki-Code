//
//  Register.h
//
//  Created by Aolly Li
//  Modified by Gian Frez


#import <UIKit/UIKit.h>

@interface Register : UITableViewController{
    BOOL isValidUsername;
    BOOL isValidFirstName;
    BOOL isValidLastName;
    BOOL isValidEmail;
    BOOL isValidAge;
    BOOL isValidCountry;
    BOOL isValidPostcode;
    BOOL isValidOrganisation;
    BOOL isValidPassword;
    NSString* ageSegment;
}

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *userFirstName;
@property (strong, nonatomic) IBOutlet UITextField *userLastName;
@property (strong, nonatomic) IBOutlet UISegmentedControl *userGenderSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *userAgeSegment;
@property (strong, nonatomic) IBOutlet UITextField *userAge;
@property (strong, nonatomic) IBOutlet UITextField *userCountry;
@property (strong, nonatomic) IBOutlet UITextField *userPostcode;
@property (strong, nonatomic) IBOutlet UITextField *userOrganisation;
@property (strong, nonatomic) IBOutlet UITextField *userEmail;
@property (strong, nonatomic) IBOutlet UITextField *userPassword;

- (IBAction)checkValidUserName:(id)sender;
- (IBAction)checkValidEmail:(id)sender;
- (IBAction)checkValidFirstName:(id)sender;
- (IBAction)checkValidLastName:(id)sender;
- (IBAction)checkValidAge:(id)sender;
- (IBAction)checkValidCountry:(id)sender;
- (IBAction)checkValidPostcode:(id)sender;
- (IBAction)checkValidOrganisation:(id)sender;
- (IBAction)checkValidPassword:(id)sender;
- (IBAction)registerUser:(id)sender;

@end

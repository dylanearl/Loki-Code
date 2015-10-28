//
//  LoginViewController.h
//
//  Created by Aolly Li
//  Modified by Gian Frez

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField * userName;
@property (nonatomic, strong) IBOutlet UITextField * userPassword;
@property (nonatomic, strong) NSArray* surveyList;

- (IBAction)loginUser:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;

@end

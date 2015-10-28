//
//  SurveyDescriptionViewController.h
//
//  Created by Aolly Li
//  Modified by Gian Frez

#import <UIKit/UIKit.h>

@interface SurveyDescriptionViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextView *surveyDescription;
@property (nonatomic, strong) IBOutlet UILabel *surveyName;
@property (nonatomic, strong) NSArray *surveyDescriptions;

@end

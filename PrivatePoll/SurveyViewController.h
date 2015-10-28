//
//  SurveyViewController.h
//
//  Created by Aolly Li
//  Modified by Gian Frez

#import <UIKit/UIKit.h>

@interface SurveyViewController : UITableViewController

@property (nonatomic, strong) NSArray *userInfo;
@property (nonatomic, strong) NSArray *sessionInfo;
@property (nonatomic) NSInteger privacy;
@property (nonatomic, strong) NSMutableArray *questionResponse;
@property (nonatomic, strong) NSArray *surveyQuestions;
@property (nonatomic) BOOL noSendErrors;
@property (nonatomic, strong) NSMutableArray *questionEnabled;

- (IBAction)cellEnabled:(id)sender;
- (IBAction)ratingChanged:(id)sender;
- (IBAction)sendResponses:(id)sender;

@end

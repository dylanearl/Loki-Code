//
//  SelectSurveyCell.h
//
//  Created by Aolly Li
//  Modified by Gian Frez

#import <UIKit/UIKit.h>

@interface SelectSurveyCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *surveyName;
@property (nonatomic, strong) IBOutlet UISegmentedControl *privacyLevel;
@property (nonatomic, strong) IBOutlet UIButton *surveyInfo;
@property (nonatomic, strong) IBOutlet UITextView *surveyDescription;
@property (strong, nonatomic) IBOutlet UILabel *surveyRequestor;
@property (strong, nonatomic) IBOutlet UILabel *surveyReward;


@end

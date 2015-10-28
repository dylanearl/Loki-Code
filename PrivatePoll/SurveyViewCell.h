//
//  SurveyViewCell.h
//
//  Created by Aolly Li
//  Modified by Gian Frez

#import <UIKit/UIKit.h>

@interface SurveyViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIButton *checkbox;
@property (nonatomic, strong) IBOutlet UILabel *questionDescription;
@property (nonatomic, strong) IBOutlet UILabel *optionOne;
@property (nonatomic, strong) IBOutlet UILabel *optionTwo;
@property (nonatomic, strong) IBOutlet UILabel *optionThree;
@property (nonatomic, strong) IBOutlet UILabel *optionFour;
@property (nonatomic, strong) IBOutlet UILabel *optionFive;
@property (nonatomic, strong) IBOutlet UISlider *userRating;

@end

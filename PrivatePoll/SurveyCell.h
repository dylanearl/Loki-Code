//
//  SurveyCell.h
//  PrivatePoll
//
//  Created by Aolly Li on 18/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIButton *checkbox;
@property (nonatomic, strong) IBOutlet UITextView *questionDescription;
@property (nonatomic, strong) IBOutlet UILabel *optionOne;
@property (nonatomic, strong) IBOutlet UILabel *optionTwo;
@property (nonatomic, strong) IBOutlet UILabel *optionThree;
@property (nonatomic, strong) IBOutlet UILabel *optionFour;
@property (nonatomic, strong) IBOutlet UILabel *optionFive;
@property (nonatomic, strong) IBOutlet UISlider *userRating;

@end

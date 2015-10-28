//
//  SelectSurveyCell.m
//
//  Created by Aolly Li
//  Modified by Gian Frez

// This file declares the UI element objects for a Select Survey cell
#import "SelectSurveyCell.h"

@implementation SelectSurveyCell
@synthesize surveyName;
@synthesize surveyInfo;
@synthesize privacyLevel;
@synthesize surveyDescription;
@synthesize surveyRequestor;
@synthesize surveyReward;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

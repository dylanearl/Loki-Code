//
//  SurveyViewCell.m
//
//  Created by Aolly Li
//  Modified by Gian Frez

#import "SurveyViewCell.h"

@implementation SurveyViewCell
@synthesize checkbox;
@synthesize questionDescription;
@synthesize optionOne, optionTwo, optionThree, optionFour, optionFive;
@synthesize userRating;

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

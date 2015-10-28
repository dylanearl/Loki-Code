//
//  SurveyCell.m
//  PrivatePoll
//
//  Created by Aolly Li on 18/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SurveyCell.h"

@implementation SurveyCell
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

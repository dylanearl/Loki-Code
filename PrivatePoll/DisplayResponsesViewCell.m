//
//  DisplayResponsesViewCell.m
//
//  Created by Aolly Li
//  Modified by Gian Frez

#import "DisplayResponsesViewCell.h"

@implementation DisplayResponsesViewCell
@synthesize result, question;

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

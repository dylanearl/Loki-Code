//
//  DisplayCell.h
//  PrivatePoll
//
//  Created by Aolly Li on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UITextView* Question;
@property (nonatomic, strong) IBOutlet UILabel *Result;

@end

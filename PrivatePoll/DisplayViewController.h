//
//  DisplayViewController.h
//  PrivatePoll
//
//  Created by Aolly Li on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *QuestionList;
@property (nonatomic, strong) NSMutableArray *ResultsList;

- (IBAction)Done:(id)sender;

@end

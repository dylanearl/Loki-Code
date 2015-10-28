//
//  DisplayResponsesViewController.h
//
//  Created by Aolly Li
//  Modified by Gian Frez

#import <UIKit/UIKit.h>

@interface DisplayResponsesViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *questionsList;
@property (nonatomic, strong) NSMutableArray *responsesList;

- (IBAction)done:(id)sender;

@end

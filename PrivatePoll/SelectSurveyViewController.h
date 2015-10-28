//
//  SelectSurveyViewController.h
//
//  Created by Aolly Li
//  Modified by Gian Frez

#import <UIKit/UIKit.h>

@interface SelectSurveyViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSIndexPath *storedIndexPath;
@property (nonatomic, strong) NSArray *userInfo;
@property (nonatomic, strong) NSArray *surveyList;

- (IBAction)infoBtn:(id)sender;


@end

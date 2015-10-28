//
//  SurveyInterface.h
//
//  Created by Aolly Li
//  Modified by Gian Frez

#import <UIKit/UIKit.h>

@interface ServerInterface : NSObject

- (NSArray*)surveyList:(NSString *)username:(NSString *)password;
- (NSArray*)surveyQuestions:(NSString *)surveyId;
- (BOOL) setPrivacy:(NSString *)survey:(NSString *)username:(NSString *)password:(NSString *)privacy;
- (BOOL) sendSurveyData:(NSString *)question:(NSString *)answer:(NSString *)username:(NSString *)password;
- (BOOL)registerUser:(NSString *)userInformation;


@end

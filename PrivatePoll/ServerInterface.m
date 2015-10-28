//
//  SurveyInterface.m
//
//  Created by Aolly Li
//  Modified by Gian Frez

#import "ServerInterface.h"
#import "Constants.h"

@implementation ServerInterface

// Register a user - pass in user information
- (BOOL)registerUser:(NSString *)userInformation
{
    // Send get request to the server
    NSString *urlAsString = WEBADDR;
    
    // Form the URL string
    urlAsString = [urlAsString stringByAppendingString:@"register/"];
    urlAsString = [urlAsString stringByAppendingString:userInformation];
    urlAsString = [urlAsString stringByAppendingString:@"/"];
    
    
    // Adds all percent escapes necessary to convert into a legal URL string. 
    NSString* escapedUrlString =
    [urlAsString stringByAddingPercentEscapesUsingEncoding:
     NSASCIIStringEncoding];
    
    // Convert the string to a URL object
    NSURL *URL = [NSURL URLWithString:escapedUrlString];
    NSLog(@"REGISTER URL = %@",URL);
    
    // Create a connection to send/receive data
    NSData *fetchData = [self fetchResponseWithURL:URL];
    
    // Save data received by fetchData as a string
    NSMutableString *receivedString = [[self stringWithData:fetchData] mutableCopy];
    
    // Deserialise received string and store as a dictionary
    NSDictionary *receivedDictionary = [self deserialiseDataDictionary:receivedString];
    
    NSLog(@"RECEIVED DICTIONARY (REGISTER USER) = %@", receivedDictionary);
    
    // Read the status number
    NSInteger errorCode = [[receivedDictionary objectForKey:@"status"]integerValue];
    
    // Recipient user name was created okay
    if (errorCode == 10){
        return YES;
    }
    else {
        return NO;
    }
    
}

// Retrieve the list of surveys from the server - pass in username and password
- (NSArray*)surveyList:(NSString *)username:(NSString *)password
{
    // Send GET request to the server
    NSString *urlAsString = WEBADDR;
    
    // Form the URL string
    urlAsString = [urlAsString stringByAppendingString:username];
    urlAsString = [urlAsString stringByAppendingString:@"/"];
    urlAsString = [urlAsString stringByAppendingString:password];
    urlAsString = [urlAsString stringByAppendingString:@"/list/"];
    
    NSURL *URL = [NSURL URLWithString:urlAsString];
    NSLog(@"SURVEY LIST URL: %@",URL);
    
    NSData *fetchData = [self fetchResponseWithURL:URL];
    
    NSMutableString *receivedString = [[self stringWithData:fetchData] mutableCopy];
    
    // Survey list is an array of dictionaries
    NSArray *receivedSurveyList = [self deserialiseDataArray:receivedString];
        
    return receivedSurveyList;
}

// Retreive survey questions, passing in the session info
- (NSArray*)surveyQuestions:(NSString *)surveyId
{
    
    NSString *urlAsString = WEBADDR;
    
    urlAsString = [urlAsString stringByAppendingString:surveyId];
    urlAsString = [urlAsString stringByAppendingString:@"/"];
    
    NSURL *URL = [NSURL URLWithString:urlAsString];
    NSLog(@"SURVEY QUESTIONS URL: %@",URL);
    
    NSData *fetchData = [self fetchResponseWithURL:URL];
    
    NSMutableString *receivedString = [[self stringWithData:fetchData] mutableCopy];
    
    // Survey questions are an array of dictionaries
    NSArray *receivedSurveyQuestions = [self deserialiseDataArray:receivedString];
    
    return receivedSurveyQuestions;
}

// Set the privacy levels, given a survey, username, password and privacy level
- (BOOL) setPrivacy:(NSString *)survey:(NSString *)username:(NSString *)password:(NSString *)privacy
{
    NSString *urlAsString = WEBADDR;
    urlAsString = [urlAsString stringByAppendingString:survey];
    urlAsString = [urlAsString stringByAppendingString:@"/"];
    urlAsString = [urlAsString stringByAppendingString:username];
    urlAsString = [urlAsString stringByAppendingString:@"/"];
    urlAsString = [urlAsString stringByAppendingString:password];
    urlAsString = [urlAsString stringByAppendingString:@"/"];
    urlAsString = [urlAsString stringByAppendingString:privacy];
    urlAsString = [urlAsString stringByAppendingString:@"/session/"];

    NSString* escapedUrlString =
    [urlAsString stringByAddingPercentEscapesUsingEncoding:
     NSASCIIStringEncoding];
    
    NSURL *URL = [NSURL URLWithString:escapedUrlString];
    
    NSLog(@"SET PRIVACY URL: %@", URL);
    
    NSData *fetchData = [self fetchResponseWithURL:URL];
    
    NSMutableString *receivedString = [[self stringWithData:fetchData] mutableCopy];
    
    // Determine if returned string status is equal to "Session updated" indicating successful update
    if ([receivedString compare: @"{\"status\": \"Session updated\"}"] == NSOrderedSame){
        return YES;
    }
    else {
        return NO;
    }
}

// Send survey data, providing the question (id), answer, username and password
- (BOOL) sendSurveyData:(NSString *)question:(NSString *)answer:(NSString *)username:(NSString *)password
{
    NSString *urlAsString = WEBADDR;
    urlAsString = [urlAsString stringByAppendingString:question];
    urlAsString = [urlAsString stringByAppendingString:@"/"];
    urlAsString = [urlAsString stringByAppendingString:answer];
    urlAsString = [urlAsString stringByAppendingString:@"/"];
    urlAsString = [urlAsString stringByAppendingString:username];
    urlAsString = [urlAsString stringByAppendingString:@"/"];
    urlAsString = [urlAsString stringByAppendingString:password];
    urlAsString = [urlAsString stringByAppendingString:@"/response/"];
    
    NSString* escapedUrlString =
    [urlAsString stringByAddingPercentEscapesUsingEncoding:
     NSASCIIStringEncoding];
    
    NSURL *URL = [NSURL URLWithString:escapedUrlString];
    
    NSLog(@"SEND SURVEY DATA URL: %@", URL);
    
    NSData *fetchData = [self fetchResponseWithURL:URL];
    
    NSMutableString *receivedString = [[self stringWithData:fetchData] mutableCopy];
    
    NSDictionary *receivedDictionary = [self deserialiseDataDictionary:receivedString];
    
    NSString *errorCode = [receivedDictionary objectForKey:@"statusString"];
    
    // No error if a response has been updated or created
    if (([errorCode compare: @"update existing response"] == NSOrderedSame) || ([errorCode compare: @"Create new response"] == NSOrderedSame)){
        return YES;
    }
    else {
        return NO;
    }
}

// Standard function to create synchronous connection (returns data - bytes)
- (NSData *)fetchResponseWithURL:(NSURL *)URL                              
{
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];              
    NSURLResponse *response = nil;                                          
    NSError *error = nil;                                                   
    NSData *fetchData = [NSURLConnection sendSynchronousRequest:request 
                                              returningResponse:&response 
                                                          error:&error];         
    if (fetchData == nil) {                                                      
        NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
    }
    
    return fetchData;                                                            
}

// Return a string containing the data retrieved by "fetchResponseWithURL"
- (NSString *)stringWithData:(NSData *)fetchData                                
{
    NSString *result = [[NSString alloc] initWithBytes:[fetchData bytes] 
                                                length:[fetchData length] 
                                              encoding:NSUTF8StringEncoding];
    
    return result;
}

// Deserialise (retrieve data from the received bytes) the JSON data from server (stored as an array)
- (NSArray *)deserialiseDataArray:(NSString*)fetchData
{
    NSError *error = nil;
    NSData *jsonReply = [fetchData dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:jsonReply
                     options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonObject != nil && error == nil){
        NSLog(@"SUCCESSFULLY DESERIALISED DATA");
        if ([jsonObject isKindOfClass:[NSArray class]]){
            NSArray *deserializedArray = (NSArray *)jsonObject;     
            return deserializedArray;
        }  
    }
    else if (error != nil){
        NSLog(@"AN ERROR HAPPENED WHILST DESERIALISING DATA: %@", error); 
    }
    else if (jsonObject == nil){
        NSLog(@"SOMETHING WENT REALLY WRONG HERE"); 
    }
    
    return NULL;
}

// Deserialise (retrieve data from the received bytes) the JSON data from server (stored as a dictionary)
- (NSDictionary *)deserialiseDataDictionary:(NSString*)fetchData
{

    NSError *error = nil;
    NSData *jsonReply = [fetchData dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:jsonReply
                     options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonObject != nil && error == nil){
        NSLog(@"SUCCESSFULLY DESERIALISED DATA");
        if ([jsonObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject; 
            return deserializedDictionary;
        } 
    }
    else if (error != nil){
        NSLog(@"AN ERROR HAPPENED WHILST DESERIALISING DATA: %@", error); 
    }
    else if (jsonObject == nil){
        NSLog(@"SOMETHING WENT REALLY WRONG HERE");
    }
    
    return NULL;
}


@end

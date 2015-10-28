//
//  Constants.h
//
//  Created by Aolly Li
//  Modified by Gian Frez

#import <Foundation/Foundation.h>

// Constants for determining if device is an iPad or iPhone
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define IPHONE   UIUserInterfaceIdiomPhone

// Constants for defining privacy levels
#define PRIVACY_NONE 1
#define PRIVACY_LOW  2
#define PRIVACY_MEDIUM 3
#define PRIVACY_HIGH  4

// Constants for dynamic resizing of survey view cells
// Change when the label size changes
#define SV_FONT_SIZE 14.0f
#define SV_IPHONE_LABEL_WIDTH 243.0f
#define SV_IPAD_LABEL_WIDTH 286.0f
#define SV_IPHONE_MARGIN 100 // Top and bottom/side to side margin combined
#define SV_IPAD_MARGIN 26

// Constants for dynamic resizing of display results cells
// Change when the label size changes
#define DR_FONT_SIZE 14.0f
#define DR_IPHONE_LABEL_WIDTH 215.0f
#define DR_IPAD_LABEL_WIDTH 620.0f
#define DR_IPHONE_MARGIN 26 // Top and bottom/side to side margin combined
#define DR_IPAD_MARGIN 50


@interface Constants : NSObject

FOUNDATION_EXPORT NSString *const WEBADDR;

@end

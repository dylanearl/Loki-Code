//
//  DiscoveryController.h
//  Test_Discovery
//
//  Created by Dylan Earl on 5/05/2015.
//  Copyright (c) 2015 Dylan Earl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoveryController: NSObject {
   NSMutableArray *xml_info;
   NSMutableArray *xml_unique;
}
@property (strong, nonatomic) NSString *property;
- (NSArray *) discover;

@end
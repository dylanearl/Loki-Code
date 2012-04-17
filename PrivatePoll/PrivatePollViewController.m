//
//  PrivatePollViewController.m
//  PrivatePoll
//
//  Created by Aolly Li on 18/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrivatePollViewController.h"

@interface PrivatePollViewController ()

@end

@implementation PrivatePollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end

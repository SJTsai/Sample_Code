//
//  SLEViewController.h
//  Memoria
//
//  Created by Simon Tsai on 3/15/14.
//  Copyright (c) 2014 Blue Moon. All rights reserved.
//

#import "SLE_BackgroundImageViewViewController.h"

@class SLEWelcomeViewController;

typedef void (^SLE_WelcomeViewControllerNextButtonTappedBlock)(SLEWelcomeViewController *welcomeViewController);

/* Shown to first-time users.
 *
 * Asks user for his/her name along with optional passcode.
 */
@interface SLEWelcomeViewController : SLE_BackgroundImageViewViewController

@property (copy, nonatomic) SLE_WelcomeViewControllerNextButtonTappedBlock nextButtonTappedBlock;

@end

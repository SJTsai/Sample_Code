//
//  SLEAppDelegate.m
//  Memoria
//
//  Created by Simon Tsai on 3/15/14.
//  Copyright (c) 2014 Blue Moon. All rights reserved.
//

#import "SLEAppDelegate.h"

#import "SLEHomeViewController.h"
#import "SLEWelcomeViewController.h"

@interface SLEAppDelegate ()

@property (strong, nonatomic) SLEWelcomeViewController *welcomeViewController;
@property (strong, nonatomic) UINavigationController *navigationControllerContainingHomeViewController;

@end

@implementation SLEAppDelegate

#pragma mark
#pragma mark - DataSources/Delegates

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.welcomeViewController = [self welcomeViewControllerFromWindowRootViewController];
    [self configureWelcomeViewController];
    
    self.navigationControllerContainingHomeViewController = [self makeNavigationControllerContainingHomeViewController];
    
    self.window.rootViewController = [self determineRootViewController];
    
    return YES;
}

#pragma mark
#pragma mark - Private Methods

#pragma mark - Welcome View Controller

/* Welcome view controller is set as root view controller by default in storyboard.
 */
- (SLEWelcomeViewController *)welcomeViewControllerFromWindowRootViewController {
    
    return (SLEWelcomeViewController *)self.window.rootViewController;
}

- (void)configureWelcomeViewController {
    
    self.welcomeViewController.nextButtonTappedBlock = [self makeWelcomeViewControllerNextButtonTappedBlock];
}

- (SLE_WelcomeViewControllerNextButtonTappedBlock)makeWelcomeViewControllerNextButtonTappedBlock {
    
    __weak typeof(self) weakSelf = self;
    
    return ^(SLEWelcomeViewController *welcomeViewController) {
        
        __strong typeof(self) strongSelf = weakSelf;
        
        [strongSelf transitionToHomeScreen];
    };
}

#pragma mark - Transition to Home Screen

- (void)transitionToHomeScreen {
    
    __weak typeof(self) weakSelf = self;
    
    [self fadeOutRootViewControllerViewWithCompletionBlock:^(BOOL finished) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.navigationControllerContainingHomeViewController.view.alpha = 0;
        
        strongSelf.window.rootViewController = strongSelf.navigationControllerContainingHomeViewController;
        
        [self fadeInRootViewControllerViewWithCompletionBlock:nil];
    }];
}

- (void)fadeOutRootViewControllerViewWithCompletionBlock:(void (^)(BOOL finished))completion {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.35 animations:^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.window.rootViewController.view.alpha = 0;
        
    } completion:completion];
}

- (void)fadeInRootViewControllerViewWithCompletionBlock:(void (^)(BOOL finished))completion {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.35 animations:^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.window.rootViewController.view.alpha = 1;
        
    } completion:completion];
}

#pragma mark - Home View Controller

- (UINavigationController *)makeNavigationControllerContainingHomeViewController
{
    return (UINavigationController *)[self makeViewControllerForStoryboardID:UIStoryboardNavigationControllerContainingHomeViewControllerID];
}

#pragma mark - Storyboard

- (UIViewController *)makeViewControllerForStoryboardID:(NSString *)storyboardID {
    
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardID];
}

#pragma mark - Root View Controller

- (UIViewController *)determineRootViewController {
    
    if ([self isNotFirstTimeUser]) {
        
        return self.navigationControllerContainingHomeViewController;
    }
    
    return self.welcomeViewController;
}

#pragma mark - User

- (BOOL)isNotFirstTimeUser {
    
    NSNumber *isNotFirstTimeUserFlag = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsIsNotFirstTimeUserKey];
    
    return [isNotFirstTimeUserFlag boolValue];
}

@end

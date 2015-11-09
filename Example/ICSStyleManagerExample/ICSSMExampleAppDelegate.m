//
//  ICSSMExampleAppDelegate.m
//  ICSStyleManagerExample
//
//  Created by Ludovico Rossi on 09/01/14.
//  Copyright (c) 2014 ice cream studios s.r.l. All rights reserved.
//

#import "ICSSMExampleAppDelegate.h"
#import "ICSSMExampleViewController.h"
#import "ICSStyleManager.h"


@implementation ICSSMExampleAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // load the style file `Example.style` bundled within the app; since this is the first
    // time we call [ICSStyleManager sharedManager], the shared manager will be automatically created
    [[ICSStyleManager sharedManager] loadStyle:@"Example"];
    
    // load the style file `Override-Example.style` bundled within the app, that will override
    // a value previosly defined by `Example.style`
    [[ICSStyleManager sharedManager] loadStyle:@"Override-Example"];
    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // obtain window's background color from the loaded style
    self.window.backgroundColor = [[ICSStyleManager sharedManager] colorForKey:@"window.backgroundColor"];
    // obtain default tint color from the loaded style
    self.window.tintColor = [[ICSStyleManager sharedManager] colorForKey:@"tintColor"];
    
    ICSSMExampleViewController *vc = [[ICSSMExampleViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    // obtain navigation bar's background and title color from the loaded style
    nc.navigationBar.barTintColor = [[ICSStyleManager sharedManager] colorForKey:@"navigationBar.backgroundColor"];
    nc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [[ICSStyleManager sharedManager] colorForKey:@"navigationBar.titleColor"]};
    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end

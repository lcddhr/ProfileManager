//
//  AppDelegate.m
//  MTProfileManager
//
//  Created by meitu on 2018/4/19.
//  Copyright © 2018年 lcd. All rights reserved.
//

#import "AppDelegate.h"
#import "MTProfileViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) MTProfileViewController *profileController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    self.profileController = [[MTProfileViewController alloc] init];
    [self.window.contentView addSubview:self.profileController.view];
    self.profileController.view.frame = self.window.contentView.bounds;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end

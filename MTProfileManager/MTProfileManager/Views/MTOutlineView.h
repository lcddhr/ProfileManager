//
//  MTOutlineView.h
//  MTProfileManager
//
//  Created by meitu on 2018/4/20.
//  Copyright © 2018年 lcd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MTMenu.h"

@protocol MTOutlineViewDelegate <NSObject>

- (void)showInFinder;
- (void)exportProfile;
- (void)moveToTrash;
- (void)importProfile;
- (void)deleteProfile;
@end

@interface MTOutlineView : NSOutlineView

@property (nonatomic, weak) id<MTOutlineViewDelegate> menuItemDelegate;

@property (nonatomic, strong) MTMenu *mainMenu;
@property (nonatomic, strong) MTMenu *itemMenu;
@property (nonatomic, strong) MTMenu *certificateMenu;
@end

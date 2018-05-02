//
//  MTAlertView.h
//  MTConfig
//
//  Created by meitu on 2018/4/18.
//  Copyright © 2018年 lcd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MTAlertViewItem;
typedef void(^MTAlertViewHandler)(MTAlertViewItem *item);
@interface MTAlertView : NSAlert

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message style:(NSAlertStyle)style;
- (void)addButtonWithTitle:(NSString *)title;
- (void)addButtonWithTitle:(NSString *)title handler:(MTAlertViewHandler)handler;
- (void)show:(NSWindow *)window ;
@end

@interface MTAlertViewItem: NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) MTAlertViewHandler action;
@end

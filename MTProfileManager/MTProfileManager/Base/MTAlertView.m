//
//  MTAlertView.m
//  MTConfig
//
//  Created by meitu on 2018/4/18.
//  Copyright © 2018年 lcd. All rights reserved.
//

#import "MTAlertView.h"

@interface MTAlertView ()

@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation MTAlertView
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message style:(NSAlertStyle)style {
    self = [super init];
    if (self != nil) {
        self.items = [NSMutableArray array];
        self.alertStyle = style;
        self.messageText = [title description];
        self.informativeText = [message description];
    }
    return self;
}

-(void)addButtonWithTitle:(NSString *)title {
    
    [self addButtonWithTitle:title handler:^(MTAlertViewItem *item) {
    }];
}

- (void )addButtonWithTitle:(NSString *)title handler:(MTAlertViewHandler)handler {
    
    MTAlertViewItem *item = [[MTAlertViewItem alloc] init];
    item.title = [title description];
    item.action = handler;
    [super addButtonWithTitle:[title description]];
    [self.items addObject:item];
    item.tag = [self.items indexOfObject:item];
}

- (void)show:(NSWindow *)window {
    
    __weak typeof(self)weakSelf = self;
    [self beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        MTAlertViewItem *item = strongSelf.items[returnCode - 1000];
        if (item.action) {
            item.action(item);
        }
    }];
}
@end

@implementation MTAlertViewItem
@end

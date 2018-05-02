//
//  MTMenu.h
//  MTProfileManager
//
//  Created by meitu on 2018/4/20.
//  Copyright © 2018年 lcd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, MTMenuType) {
    MTMenuTypeMain,
    MTMenuTypeItem,
};

@protocol MTMenuDelegate <NSMenuDelegate>

@end;

@interface MTMenu : NSMenu

@property (nonatomic, weak) id<MTMenuDelegate> delegate;

-(instancetype)initWithMenuType:(MTMenuType)type;
@end

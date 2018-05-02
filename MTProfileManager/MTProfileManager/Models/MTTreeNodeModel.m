//
//  MTTreeNodeModel.m
//  MTProfileManager
//
//  Created by meitu on 2018/4/20.
//  Copyright © 2018年 lcd. All rights reserved.
//

#import "MTTreeNodeModel.h"

@implementation MTTreeNodeModel

-(instancetype)init {
    self = [super init];
    if (self) {
        
        self.childNodes = [NSMutableArray array];
    }
    return self;
}
@end

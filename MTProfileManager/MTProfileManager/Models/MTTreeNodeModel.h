//
//  MTTreeNodeModel.h
//  MTProfileManager
//
//  Created by meitu on 2018/4/20.
//  Copyright © 2018年 lcd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTTreeNodeModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSMutableArray *childNodes;

@end

//
//  MTFilePathManager.h
//  MTProfileManager
//
//  Created by meitu on 2018/4/19.
//  Copyright © 2018年 lcd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTFileManager : NSObject

+ (instancetype)sharedInstance;


- (NSString *)profileDirectory;


- (BOOL)deleteFile:(NSString *)filePath option:(BOOL)totle;

@end

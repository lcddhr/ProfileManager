//
//  MTFilePathManager.m
//  MTProfileManager
//
//  Created by meitu on 2018/4/19.
//  Copyright © 2018年 lcd. All rights reserved.
//

#import "MTFileManager.h"
#import <Cocoa/Cocoa.h>

@implementation MTFileManager

+ (instancetype)sharedInstance {
    static MTFileManager *filePathManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        filePathManager = [[MTFileManager alloc] init];
    });
    return filePathManager;
}

- (NSString *)profileDirectory {
    
    NSString *profileDirectory =  [NSString stringWithFormat:@"%@/Library/MobileDevice/Provisioning Profiles/",NSHomeDirectory()];
    return profileDirectory;
    
}

- (BOOL)deleteFile:(NSString *)filePath option:(BOOL)totle {
    
    NSError *error;
    BOOL result = NO;
    if (totle) {
        result = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    } else {
        result = [self moveFileToTrashPath:filePath error:&error];
    }
    
    if (error) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:[error localizedDescription]];
        [alert beginSheetModalForWindow:NSApp.keyWindow completionHandler:^(NSModalResponse returnCode) {
        }];
    }
    return result;
}

- (BOOL)moveFileToTrashPath:(NSString *)path error:(NSError **)error {
    NSParameterAssert(path != nil);
    NSString *trashPath = [NSString stringWithFormat:@"%@/.Trash", NSHomeDirectory()];
    NSString *proposedPath = [trashPath stringByAppendingPathComponent:[path lastPathComponent]];
    return [[NSFileManager defaultManager] moveItemAtPath:path toPath:[self uniqueFileNameWithPath:proposedPath] error:error];
}

- (NSString *)uniqueFileNameWithPath:(NSString *)aPath {
    NSParameterAssert(aPath != nil);
    
    NSString *baseName = [aPath stringByDeletingPathExtension];
    NSString *suffix = [aPath pathExtension];
    NSUInteger n = 2;
    NSString *fname = aPath;
    
    while ([[NSFileManager defaultManager] fileExistsAtPath:fname]) {
        if ([suffix length] == 0)
            fname = [baseName stringByAppendingString:[NSString stringWithFormat:@" %zi", n++]];
        else
            fname = [baseName stringByAppendingString:[NSString stringWithFormat:@" %zi.%@", n++, suffix]];
        
        if (n <= 0)
            return nil;
    }
    
    return fname;
}
@end

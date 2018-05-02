//
//  NSDate+Base64.h
//  MTProfileManager
//
//  Created by meitu on 2018/4/20.
//  Copyright © 2018年 lcd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

- (NSString *)mt_base64EncodeString;

+ (NSData *)mt_dataWithBase64EncodedString:(NSString *)string;
@end

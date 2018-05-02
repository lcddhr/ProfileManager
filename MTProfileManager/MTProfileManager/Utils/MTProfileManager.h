//
//  MTProfileManager.h
//  MTProfileManager
//
//  Created by meitu on 2018/4/19.
//  Copyright © 2018年 lcd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTProfileManager : NSObject

- (NSArray *)loadProfileData;

- (NSDictionary *)parseCertificate:(NSData *)data;
@end

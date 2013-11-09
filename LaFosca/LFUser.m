//
//  LFUser.m
//  LaFosca
//
//  Created by Marc Llucià on 09/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import "LFUser.h"

@implementation LFUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userName": @"username",
             @"token": @"authentication_token"
             };
}

@end

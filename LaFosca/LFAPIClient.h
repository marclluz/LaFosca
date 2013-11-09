//
//  LFAPIClient.h
//  LaFosca
//
//  Created by Marc Llucià on 09/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface LFAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;


@end

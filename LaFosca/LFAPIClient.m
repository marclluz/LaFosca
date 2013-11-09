//
//  LFAPIClient.m
//  LaFosca
//
//  Created by Marc Llucià on 09/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import "LFAPIClient.h"

static NSString * const LFAPIBaseURLString = @"http://lafosca-beach.herokuapp.com/api/v1/";

@implementation LFAPIClient

+ (instancetype)sharedClient {
    static LFAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[LFAPIClient alloc] initWithBaseURL:[NSURL URLWithString:LFAPIBaseURLString]];

    });
    
    return _sharedClient;
}

@end

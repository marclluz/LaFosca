//
//  LFAPIClient.m
//  LaFosca
//
//  Created by Marc Llucià on 09/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import "LFAPIClient.h"
#import "DataModel.h"

static NSString * const LFAPIBaseURLString = @"http://lafosca-beach.herokuapp.com/api/v1/";

@implementation LFAPIClient

+ (instancetype)sharedClient {
    static LFAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[LFAPIClient alloc] initWithBaseURL:[NSURL URLWithString:LFAPIBaseURLString]];
        
        _sharedClient.responseSerializer  = [AFJSONResponseSerializer new];
        
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json", @"application/json", nil];
        
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //Listen when token changes
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tokenChanged:)
                                                     name:@"tokenChanged"
                                                   object:nil];
    }
    return self;
}


- (void)setTokenHeader {
    NSString *token = [NSString stringWithFormat:@"Token token=\"%@\"", [[[DataModel sharedInstance]user]token]];
    
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:token forHTTPHeaderField:@"Authorization"];
    self.requestSerializer = serializer;

}

- (void)tokenChanged:(NSNotification *)notification {
    [self setTokenHeader];
}

@end

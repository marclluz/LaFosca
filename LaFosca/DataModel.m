//
//  DataModel.m
//  LaFosca
//
//  Created by Marc Llucià on 09/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel


+(instancetype) sharedInstance {
    
    static DataModel *singleton = nil;
        
    if (nil != singleton) return singleton;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{

        singleton = [[DataModel alloc] init];
        
    });
    
    return singleton;
    
}

- (void)setUser:(LFUser *)newUser
{
  
    _user = newUser;
    
    //We have a new token
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tokenChanged" object:self];
}

@end

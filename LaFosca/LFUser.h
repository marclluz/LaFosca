//
//  LFUser.h
//  LaFosca
//
//  Created by Marc Llucià on 09/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface LFUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *userName;
@property (nonatomic, copy, readonly) NSString *token;

@end

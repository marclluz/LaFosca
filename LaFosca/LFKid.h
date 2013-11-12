//
//  LFKid.h
//  LaFosca
//
//  Created by Marc Llucià on 12/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface LFKid : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *age;
@property (nonatomic, copy, readonly) NSString *name;

@end

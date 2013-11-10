//
//  LFBeach.h
//  LaFosca
//
//  Created by Marc Llucià on 10/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef enum : NSUInteger {
    LFBeachStateOpen,
    LFBeachStateLoading,
    LFBeachStateClosed
} LFBeachState;

typedef enum : NSUInteger {
    LFBeachGreenFlag,
    LFBeachYellowFlag,
    LFBeachRedFlag
} LFBeachFlag;

@interface LFBeach : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *happiness;
@property (nonatomic, copy, readonly) NSNumber *dirtiness;
@property (nonatomic, copy, readonly) NSArray *kids;
@property (nonatomic, assign, readonly) LFBeachState state;
@property (nonatomic, assign, readonly) LFBeachFlag flag;

@end

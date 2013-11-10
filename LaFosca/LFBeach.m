//
//  LFBeach.m
//  LaFosca
//
//  Created by Marc Llucià on 10/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import "LFBeach.h"

@implementation LFBeach

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"happiness": @"happiness",
             @"dirtiness": @"dirtiness",
             @"kids": @"kids",
             @"state": @"state",
             @"flag": @"flag"
             };
}

+ (NSValueTransformer *)stateJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"open": @(LFBeachStateOpen),
                                                                           @"closed": @(LFBeachStateClosed)
                                                                           }];
}


@end

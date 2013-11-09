//
//  DataModel.h
//  LaFosca
//
//  Created by Marc Llucià on 09/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFUser.h"

@interface DataModel : NSObject

@property (nonatomic, retain) LFUser *user;

+ (instancetype)sharedInstance;


@end

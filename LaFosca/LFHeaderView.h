//
//  LFHeaderView.h
//  LaFosca
//
//  Created by Marc Llucià on 10/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBeach.h"

@interface LFHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *statsView;
@property (weak, nonatomic) IBOutlet UIButton *centralButton;
@property (weak, nonatomic) IBOutlet UIButton *subtitleButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *happinessLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *dirtinessLevelLabel;

- (void) switchState:(LFBeachState)state;


@end

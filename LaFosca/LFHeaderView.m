//
//  LFHeaderView.m
//  LaFosca
//
//  Created by Marc Llucià on 10/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import "LFHeaderView.h"

@implementation LFHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) switchState:(LFBeachState)state
{
    switch (state) {
        case LFBeachStateLoading:
            
            [self.centralButton setEnabled:NO];
            [self.centralButton setImage:nil forState:UIControlStateNormal];
            [self.activityIndicator setHidden:NO];
            [self.subtitleButton setTitle:@"Cargando" forState:UIControlStateNormal];
            [self.subtitleButton setEnabled:NO];
            break;
            
        case LFBeachStateOpen:
        {
            [self.centralButton setEnabled:YES];
            [self.activityIndicator setHidden:YES];
            [self.subtitleButton setTitle:@"Lanzar pelotas de nivea" forState:UIControlStateNormal];
            [self.subtitleButton setEnabled:YES];
            
            UIImage* flagImage = [UIImage imageNamed:@"flag.png"];
            [self.centralButton setImage:flagImage forState:UIControlStateNormal];
        }
            break;
            
        case LFBeachStateClosed:
        {
            [self.centralButton setEnabled:NO];
            [self.activityIndicator setHidden:YES];
            [self.subtitleButton setTitle:@"Limpiar playa" forState:UIControlStateNormal];
            [self.subtitleButton setEnabled:YES];
            
            UIImage* lockImage = [UIImage imageNamed:@"lock.png"];
            [self.centralButton setImage:lockImage forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

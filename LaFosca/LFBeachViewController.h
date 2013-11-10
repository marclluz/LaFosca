//
//  LFBeachViewController.h
//  LaFosca
//
//  Created by Marc Llucià on 09/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBeach.h"
@interface LFBeachViewController : UIViewController <UIScrollViewDelegate>
{
    LFBeach* beach;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@end

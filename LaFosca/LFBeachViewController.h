//
//  LFBeachViewController.h
//  LaFosca
//
//  Created by Marc Llucià on 09/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBeach.h"
#import "LFHeaderView.h"

@interface LFBeachViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, UISearchBarDelegate>
{
    LFBeach* beach;
    NSMutableArray *tableDataSource;
    BOOL isReloading;
}

@property (strong, nonatomic) IBOutlet LFHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)flagButtonPressed:(id)sender;
- (IBAction)subButtonPressed:(id)sender;

@end

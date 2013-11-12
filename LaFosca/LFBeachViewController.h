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
    NSArray *tableDataSource;
    NSMutableArray *filteredDataSource;

    BOOL isReloading;
}

@property (strong, nonatomic) IBOutlet LFHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *kidsTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)flagButtonPressed:(id)sender;
- (IBAction)subButtonPressed:(id)sender;

@end

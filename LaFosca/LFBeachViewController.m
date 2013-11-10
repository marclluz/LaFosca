//
//  LFBeachViewController.m
//  LaFosca
//
//  Created by Marc Llucià on 09/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import "LFBeachViewController.h"
#import "LFAPIClient.h"
#import "UIImage+Tint.h"

@interface LFBeachViewController ()

@end

@implementation LFBeachViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBarButtons];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController.navigationBar setTintColor:BASE_COLOR];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self setTableViewHeader];
    
    [self getBeachData];
}

- (void) setNavigationBarButtons
{
    UIBarButtonItem* logoutBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
    [self.navigationItem setLeftBarButtonItem:logoutBarButtonItem];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void) getBeachData
{
    [self switchToState:LFBeachStateLoading];
    LFAPIClient* client = [LFAPIClient sharedClient];
    
    [client GET:@"state" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError *error = nil;

        beach = [MTLJSONAdapter modelOfClass:LFBeach.class fromJSONDictionary:responseObject error:&error];
        
        [self switchToState:beach.state];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void) switchToState:(LFBeachState) state
{
    [self.headerView switchState:state];

    switch (state) {
        case LFBeachStateLoading:
        {
            [self.navigationItem setRightBarButtonItem:nil];
        }
            break;
            
        case LFBeachStateOpen:
        {
            UIBarButtonItem* changeStatusBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cerrar playa" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
            [self.navigationItem setRightBarButtonItem:changeStatusBarButtonItem];
            [self setFlagColor];
        }
            break;
            
        case LFBeachStateClosed:
        {
            UIBarButtonItem* changeStatusBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Abrir playa" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
            [self.navigationItem setRightBarButtonItem:changeStatusBarButtonItem];
        }
            break;
            
        default:
            [self.navigationItem setRightBarButtonItem:nil];
            break;
    }
}

- (void) setFlagColor
{
    
    UIColor* flagColor;
    switch (beach.flag) {
        case LFBeachGreenFlag:
            
            flagColor = [UIColor greenColor];
            break;
        case LFBeachRedFlag:
            
            flagColor = [UIColor redColor];
            break;
        case LFBeachYellowFlag:
            
            flagColor = [UIColor yellowColor];
            break;
            
        default:
            break;
    }
    
    UIImage* flagImage = [UIImage imageNamed:@"flag.png"];
    flagImage = [flagImage imageTintedWithColor:flagColor];
    [self.headerView.centralButton setImage:flagImage forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableViewHeader
{
    [self.tableView setTableHeaderView:self.headerView];
}

#pragma mark - UITableView Datasource



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
        
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end

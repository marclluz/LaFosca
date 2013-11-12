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
    isReloading = NO;
    
    [self setNavigationBarButtons];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController.navigationBar setTintColor:BASE_COLOR];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self setTableViewHeader];
    
    [self switchToState:LFBeachStateLoading];
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

#pragma mark Server Requests

- (void) getBeachData
{
    LFAPIClient* client = [LFAPIClient sharedClient];
    
    [client GET:@"state" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError *error = nil;

        beach = [MTLJSONAdapter modelOfClass:LFBeach.class fromJSONDictionary:responseObject error:&error];
        
        [self switchToState:beach.state];
        [self fillData];
        //reload data every 5 seconds
        if(!isReloading)
        {
            isReloading = YES;
            double delay = 5.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                isReloading = NO;
                [self getBeachData];
            });
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void) closeBeach
{
    LFAPIClient* client = [LFAPIClient sharedClient];

    [client PUT:@"close" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self getBeachData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void) openBeach
{
    LFAPIClient* client = [LFAPIClient sharedClient];
    
    [client PUT:@"open" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self getBeachData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void) setFlag:(NSInteger)flagIndex
{
    NSDictionary* params = @{@"flag": [NSNumber numberWithInt:flagIndex]};
    
    LFAPIClient* client = [LFAPIClient sharedClient];
    [client PUT:@"flag" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [self getBeachData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void) cleanBeach
{
    LFAPIClient* client = [LFAPIClient sharedClient];
    
    [client POST:@"clean" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self getBeachData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void) niveaRain
{
    LFAPIClient* client = [LFAPIClient sharedClient];
    
    [client POST:@"nivea-rain" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self getBeachData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark UI interaction

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
            UIBarButtonItem* changeStatusBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cerrar playa" style:UIBarButtonItemStylePlain target:self action:@selector(closeBeach)];
            [self.navigationItem setRightBarButtonItem:changeStatusBarButtonItem];
            [self setFlagColor];
            
            //Kids change every time we reload, we stay with the first response
            if (!tableDataSource) {
                tableDataSource = [NSMutableArray arrayWithArray:beach.kids];
                [self.tableView reloadData];

            }
        }
            break;
            
        case LFBeachStateClosed:
        {
            UIBarButtonItem* changeStatusBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Abrir playa" style:UIBarButtonItemStylePlain target:self action:@selector(openBeach)];
            [self.navigationItem setRightBarButtonItem:changeStatusBarButtonItem];
        }
            break;
            
        default:
            [self.navigationItem setRightBarButtonItem:nil];
            break;
    }
}

- (void) fillData
{
    [self.headerView.happinessLevelLabel setText:[NSString stringWithFormat:@"%@",beach.happiness]];
    [self.headerView.dirtinessLevelLabel setText:[NSString stringWithFormat:@"%@",beach.dirtiness]];

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

- (IBAction)flagButtonPressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Selecciona el color de la bandera:" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:
                            @"Bandera Verde",
                            @"Bandera Amarilla",
                            @"Bandera Roja",
                            nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)subButtonPressed:(id)sender {
    
    if (beach.state == LFBeachStateOpen) {
        [self niveaRain];
    }
    else
    {
        [self cleanBeach];
    }
}

-(void)filterContentForSearchText:(NSString*)searchText {

    if (searchText.length == 0) {
        tableDataSource = [NSMutableArray arrayWithArray:beach.kids];

    }
    else
    {
        [tableDataSource removeAllObjects];
        // Filter the array using NSPredicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@",searchText];
        
        tableDataSource = [NSMutableArray arrayWithArray:[beach.kids filteredArrayUsingPredicate:predicate]];
    }
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

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self setFlag:buttonIndex];
}

#pragma mark - UITableView Datasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.searchBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary* kid = [tableDataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [kid objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ años", [kid objectForKey:@"age"]];

    return cell;
}


#pragma mark - UISearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //hide the header to scroll the search bar to top
    self.tableView.tableHeaderView = nil;
    [searchBar setShowsCancelButton:YES animated:YES];
    
    CGSize contentSize = self.tableView.contentSize;
    
    //add keyboard height
    contentSize.height += 216;
    [self.tableView setContentSize:contentSize];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    

    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:NO];
    [searchBar resignFirstResponder];
    [self setTableViewHeader];
    tableDataSource = [NSMutableArray arrayWithArray:beach.kids];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [self filterContentForSearchText:searchBar.text];
    
    [self.tableView reloadData];
    [self.searchBar becomeFirstResponder];

}


@end

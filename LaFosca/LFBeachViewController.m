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
#import "LFKid.h"
#import "DataModel.h"

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
    
    [self switchToState:LFBeachStateLoading];
    [self getBeachData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self showWelcomeMessage];

}

- (void)viewWillDisappear:(BOOL)animated
{
    //we cancel all task before we leave
    LFAPIClient* client = [LFAPIClient sharedClient];

    for (NSURLSessionTask *task in client.tasks) {
        [task cancel];
    }
    
    [timer invalidate];
}
- (void) setNavigationBarButtons
{
    UIBarButtonItem* logoutBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
    [self.navigationItem setLeftBarButtonItem:logoutBarButtonItem];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void) logOut
{
    [[DataModel sharedInstance] setUser:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) showWelcomeMessage
{
    NSString* welcomeMessage = [NSString stringWithFormat:@"¡Hola %@!",[[[DataModel sharedInstance] user] userName]];
    
    [ProgressHUD showSuccess:welcomeMessage];

}

#pragma mark Server Requests

- (void) getBeachData
{
    LFAPIClient* client = [LFAPIClient sharedClient];
    
    [client GET:@"state" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        [timer invalidate];
        
        NSError *error = nil;

        beach = [MTLJSONAdapter modelOfClass:LFBeach.class fromJSONDictionary:responseObject error:&error];
        
        [self switchToState:beach.state];
        [self fillData];

        //reload data every 5 seconds
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                             target:self
                                           selector:@selector(getBeachData)
                                           userInfo:nil
                                            repeats:NO];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No se han podido obtener los datos de la playa" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [errorAlertView show];

        
    }];
}

- (void) closeBeach
{
    LFAPIClient* client = [LFAPIClient sharedClient];

    [ProgressHUD show:@"Cerrando playa"];
    
    [client PUT:@"close" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [ProgressHUD showSuccess:@"Playa cerrada"];

        
        [self getBeachData];
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [ProgressHUD dismiss];
        UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No se ha podido cerrar la playa" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [errorAlertView show];

    }];
}

- (void) openBeach
{
    LFAPIClient* client = [LFAPIClient sharedClient];
    
    [ProgressHUD show:@"Abriendo playa"];
    
    [client PUT:@"open" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [ProgressHUD showSuccess:@"Playa abierta"];

        [self getBeachData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [ProgressHUD dismiss];
        UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No se ha podido abrir la playa" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [errorAlertView show];

    }];
}

- (void) setFlag:(NSInteger)flagIndex
{
    [ProgressHUD show:@"Cambiando bandera"];
    
    NSDictionary* params = @{@"flag": [NSNumber numberWithInt:flagIndex]};
    
    LFAPIClient* client = [LFAPIClient sharedClient];
    [client PUT:@"flag" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [ProgressHUD showSuccess:@"Bandera cambiada"];
        [self getBeachData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [ProgressHUD dismiss];
        UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No se ha podido cambiar el color de la bandera" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [errorAlertView show];

        
    }];
}

- (void) cleanBeach
{
    
    [ProgressHUD show:@"Limpiando playa"];
    LFAPIClient* client = [LFAPIClient sharedClient];
    
    [client POST:@"clean" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [ProgressHUD showSuccess:@"Playa limpiada"];

        [self getBeachData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [ProgressHUD dismiss];
        UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No se ha podido limpiar la playa" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [errorAlertView show];

    }];
}

- (void) niveaRain
{
    [ProgressHUD show:@"Tirando pelotas de nivea"];
    LFAPIClient* client = [LFAPIClient sharedClient];
    
    [client POST:@"nivea-rain" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [ProgressHUD showSuccess:@"Pelotas tiradas"];
        [self getBeachData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [ProgressHUD dismiss];
        UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No se han podido tirar pelotas de nivea" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [errorAlertView show];

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
            
            //Kids change every time we reload, we stay with the first response to show the filter feature
            if (!tableDataSource) {
                tableDataSource = [NSArray arrayWithArray:beach.kids];
                filteredDataSource = [NSMutableArray arrayWithArray:tableDataSource];

                [self.kidsTableView reloadData];

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
        filteredDataSource = [NSMutableArray arrayWithArray:tableDataSource];

    }
    else
    {
        [filteredDataSource removeAllObjects];
        // Filter the array using NSPredicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@",searchText];
        
        filteredDataSource = [NSMutableArray arrayWithArray:[tableDataSource filteredArrayUsingPredicate:predicate]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableViewHeader
{
    [self.kidsTableView setTableHeaderView:self.headerView];
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
    
    //everytime we call reloadData we sort de datasource array
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    [filteredDataSource sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return filteredDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    LFKid* kid = [filteredDataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = kid.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ años", kid.age];

    return cell;
}


#pragma mark - UISearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //hide the header to scroll the search bar to top
    self.kidsTableView.tableHeaderView = nil;
    [searchBar setShowsCancelButton:YES animated:YES];
    
    CGSize contentSize = self.kidsTableView.contentSize;
    
    //add keyboard height
    contentSize.height += 216;
    [self.kidsTableView setContentSize:contentSize];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    

    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:NO];
    [searchBar resignFirstResponder];
    [self setTableViewHeader];
    filteredDataSource = [NSMutableArray arrayWithArray:tableDataSource];
    [self.kidsTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [self filterContentForSearchText:searchBar.text];
    
    [self.kidsTableView reloadData];
    [self.searchBar becomeFirstResponder];

}


@end

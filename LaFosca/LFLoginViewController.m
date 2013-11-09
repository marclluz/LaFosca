//
//  LFLoginViewController.m
//  LaFosca
//
//  Created by Marc Llucià on 08/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import "LFUser.h"
#import "LFLoginViewController.h"
#import "LFAPIClient.h"
#import "DataModel.h"
#import "LFRegisterViewController.h"

@interface LFLoginViewController ()

@end

@implementation LFLoginViewController

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
    [self setTitle:@""];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    
    [self setButtonsEnabled:NO];
    
    LFAPIClient* client = [LFAPIClient sharedClient];
    
    [client setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [client.requestSerializer setAuthorizationHeaderFieldWithUsername:self.userTextField.text password:self.passwordTextField.text];
    
    [client GET:@"user" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError *error = nil;
        LFUser* user = [MTLJSONAdapter modelOfClass:LFUser.class fromJSONDictionary:responseObject error:&error];
        
        [[DataModel sharedInstance] setUser:user];
        [self setButtonsEnabled:YES];


    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Parece que hay un error con los datos introducidos, por favor revisa tu usuario y contraseña" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [errorAlertView show];
        [self setButtonsEnabled:YES];

    }];
    
}

- (void) setButtonsEnabled:(BOOL) boolean
{
    [self.loginButton setEnabled:boolean];
    [self.registerButton setEnabled:boolean];
}

- (IBAction)registerButtonPressed:(id)sender {
    
    LFRegisterViewController* registerViewController = [[LFRegisterViewController alloc] init];
    
    [self.navigationController pushViewController:registerViewController animated:YES];
    
}
@end

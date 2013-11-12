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
#import "LFBeachViewController.h"

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
    [self setNeedsStatusBarAppearanceUpdate];
    [self setTitle:@""];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    
    [self logIn];
    
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

- (void) logIn
{
    [self setButtonsEnabled:NO];
    [ProgressHUD show:@"Entrando"];
    LFAPIClient* client = [LFAPIClient sharedClient];
    
    [client setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [client.requestSerializer setAuthorizationHeaderFieldWithUsername:self.userTextField.text password:self.passwordTextField.text];
    
    [client GET:@"user" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError *error = nil;
        LFUser* user = [MTLJSONAdapter modelOfClass:LFUser.class fromJSONDictionary:responseObject error:&error];
        
        //if we get the user without errors we push the beach view
        if (user&&!error)
        {
            [[DataModel sharedInstance] setUser:user];
            
            LFBeachViewController *beachViewController = [[LFBeachViewController alloc] init];
            UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:beachViewController];
            [navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:navController animated:YES completion:^{
                
                //reset textfields
                [self.userTextField setText:@""];
                [self.passwordTextField setText:@""];
            }];
        }
        
        [self setButtonsEnabled:YES];
        [ProgressHUD dismiss];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Parece que hay un error con los datos introducidos, por favor revisa tu usuario y contraseña" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [errorAlertView show];
        [self setButtonsEnabled:YES];
        [ProgressHUD dismiss];
        
    }];
}

#pragma mark UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self.scrollView setContentOffset:CGPointMake(0, 220) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    //Navigate through form
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [self.view viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [textField resignFirstResponder];
        [self logIn];
    }
    return NO;
}


@end

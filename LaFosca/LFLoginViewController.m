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
    [self setTitle:@"La Fosca"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    
    LFAPIClient* client = [LFAPIClient sharedClient];
    
    [client setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [client.requestSerializer setAuthorizationHeaderFieldWithUsername:self.userTextField.text password:self.passwordTextField.text];
    
    [client GET:@"user" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError *error = nil;
        LFUser* user = [MTLJSONAdapter modelOfClass:LFUser.class fromJSONDictionary:responseObject error:&error];
        
        [[DataModel sharedInstance] setUser:user];
        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Parece que hay un error con los datos introducidos, por favor revisa tu usuario y contraseña" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [errorAlertView show];
        
    }];
    
}

- (IBAction)registerButtonPressed:(id)sender {
}
@end

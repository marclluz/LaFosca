//
//  LFLoginViewController.m
//  LaFosca
//
//  Created by Marc Llucià on 08/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import "LFLoginViewController.h"
#import "LFAPIClient.h"
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
        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (IBAction)registerButtonPressed:(id)sender {
}
@end

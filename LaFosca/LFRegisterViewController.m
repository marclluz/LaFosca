//
//  LFRegisterViewController.m
//  LaFosca
//
//  Created by Marc Llucià on 09/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import "LFRegisterViewController.h"
#import "LFAPIClient.h"
#import "LFUser.h"
#import "DataModel.h"

@interface LFRegisterViewController ()

@end

@implementation LFRegisterViewController

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.title = @"Registro";
    
    [self.userTextField setDelegate:self];
    [self.passwordTextField setDelegate:self];
    [self.confirmPasswordTextfield setDelegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkPasswordMatch
{
    
    //Trim de password strings to remove whitespaces at start and end
    NSString *password =self.passwordTextField.text;
    NSString *trimmedPassword= [password stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *confirmPassword =self.confirmPasswordTextfield.text;
    NSString *trimmedConfirmPassword= [confirmPassword stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *user =self.userTextField.text;
    NSString *trimmedUser= [user stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
   

    //check if form is filled
    if (trimmedConfirmPassword.length==0 || trimmedPassword.length==0 || trimmedUser.length==0) {
        UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Comprueba que todos los campos han sido rellenados" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [errorAlertView show];
    }
    //check if passwords match
    else if ([trimmedPassword isEqualToString:trimmedConfirmPassword]) {
        [self registerUser];
    }
    else
    {
        UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Parece que tus contraseñas no coinciden, por favor revisa los campos" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [errorAlertView show];
    }
}

- (void) registerUser
{    
    NSDictionary* params = @{@"user":@{
                            @"username":self.userTextField.text,
                            @"password":self.passwordTextField.text}};
    
    LFAPIClient* client = [LFAPIClient sharedClient];
    
    [client POST:@"users" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError *error = nil;
        LFUser* user = [MTLJSONAdapter modelOfClass:LFUser.class fromJSONDictionary:responseObject error:&error];
        
        [[DataModel sharedInstance] setUser:user];

    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Ha ocurrido un error al intentar registrar este usuario" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [errorAlertView show];
        
    }];
}


- (IBAction)registerUserPressed:(id)sender {
    
    [self checkPasswordMatch];
}

#pragma mark UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    //Navigate through form
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [self.view viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self checkPasswordMatch];
    }
    return NO;
}

@end

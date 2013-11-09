//
//  LFLoginViewController.h
//  LaFosca
//
//  Created by Marc Llucià on 08/11/13.
//  Copyright (c) 2013 Marc Llucià. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>

@interface LFLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;

@end

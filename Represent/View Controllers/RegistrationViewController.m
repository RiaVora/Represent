//
//  RegistrationViewController.m
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "RegistrationViewController.h"
#import "Utils.h"
#import "User.h"

@interface RegistrationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@end

@implementation RegistrationViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Actions

- (IBAction)pressedSignUp:(id)sender {
    NSString *firstName = self.firstNameField.text;
    NSString *email = self.emailField.text;
    NSString *zipcode = self.zipcodeField.text;
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    NSString *confirmPassword = self.confirmPasswordField.text;
    BOOL firstNameExists = [Utils checkExists:firstName :@"First Name" :self];
    BOOL emailExists = [Utils checkExists:email :@"Email" :self];
    BOOL zipcodeExists = [Utils checkExists:zipcode :@"Zipcode" :self];
    BOOL usernameExists = [Utils checkExists:username :@"Username" :self];
    BOOL passwordExists = [Utils checkExists:password :@"Password" :self];
    BOOL confirmPasswordExists = [Utils checkExists:confirmPassword :@"Confirm Password" :self];
    BOOL allExist = firstNameExists && emailExists && zipcodeExists && usernameExists && passwordExists && confirmPasswordExists;
    
    if (allExist) {
        
    }
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"signedInSegue"]) {
        
    }

}


@end

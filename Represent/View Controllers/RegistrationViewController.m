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
@property (weak, nonatomic) IBOutlet UITextField *stateField;
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
    if ([self checkAllCorrect]) {
        User *user = [User new];
        [user signUpUser:self.firstNameField.text email:self.emailField.text state:self.stateField.text username:self.usernameField.text password:self.passwordField.text isRepresentative:NO withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Success in signing up user %@, welcome %@!", user.username, user.firstName);
//                [user getRepresentatives];
                [User logInWithUsername:user.username password:user.password];
                [user saveInBackground];
                [self performSegueWithIdentifier:@"signInSegue" sender:sender];
                
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
                [Utils displayAlertWithOk:@"Error with signing up" message:error.localizedDescription viewController:self];
            }
        }];
        
    }
    
    
}

- (BOOL)checkAllCorrect {
    BOOL firstNameExists = [Utils checkExists:self.firstNameField.text :@"First Name" :self];
    BOOL emailExists = [Utils checkExists:self.emailField.text :@"Email" :self];
    BOOL stateExists = [Utils checkExists:self.stateField.text :@"Zipcode" :self];
    BOOL usernameExists = [Utils checkExists:self.usernameField.text :@"Username" :self];
    BOOL passwordExists = [Utils checkExists:self.passwordField.text :@"Password" :self];
    BOOL confirmPasswordExists = [Utils checkExists:self.confirmPasswordField.text :@"Confirm Password" :self];
    BOOL stateLengthCorrect = [Utils checkLength:self.stateField.text :@(2) :@"State" :self];
    BOOL passwordsEqual = [Utils checkEquals:self.passwordField.text :self.confirmPasswordField.text :@"Password do not match, please try again." :self];
    return firstNameExists && emailExists && stateExists && usernameExists && passwordExists && confirmPasswordExists && stateLengthCorrect && passwordsEqual;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"signedInSegue"]) {
        
    }

}


@end

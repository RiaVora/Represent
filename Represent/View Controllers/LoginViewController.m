//
//  ViewController.m
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "LoginViewController.h"
#import "Question.h"
#import <Parse/Parse.h>
#import "Utils.h"
#import "APIManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "PFFacebookUtils.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;


@end

@implementation LoginViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.facebookButton.layer.cornerRadius = 10;
}

#pragma mark - Setup
- (void)setUpSenate {
    APIManager *manager = [APIManager new];
    [manager fetchSenators:^(NSArray * _Nonnull senators, NSError * _Nonnull error) {
        if (!error) {
            for (NSDictionary *senator in senators) {
                if (senator[@"in_office"]) {
                    [User signUpRepresentative:senator];
                }
            }
        }
    }];
}

- (void)setUpHouse {
    APIManager *manager = [APIManager new];
    [manager fetchHouseReps:^(NSArray * _Nonnull reps, NSError * _Nonnull error) {
        if (!error) {
            for (NSDictionary *rep in reps) {
                if (rep[@"in_office"]) {
                    [User signUpRepresentative:rep];
                    //                    NSLog(@"%@", rep);
                }
            }
        }
    }];
}

#pragma mark - Actions

- (IBAction)pressedLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    BOOL usernameExists = [Utils checkExists:username :@"Username" :self];
    BOOL passwordExists = [Utils checkExists:password :@"Password" :self];
    
    if (usernameExists && passwordExists) {
        [User logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %ld", error.code);
                [Utils displayAlertWithOk: @"Error with Logging In" message:error.localizedDescription viewController:self];
            } else {
                NSLog(@"User %@ logged in successfully", username);
                self.usernameField.text = @"";
                self.passwordField.text = @"";
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
}
- (IBAction)pressedFacebook:(FBSDKLoginButton *)sender {
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"public_profile", @"email"] block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with logging in given Facebook user with Parse: %@", error.localizedDescription);
        } else if (!user) {
            NSLog(@"User cancelled!");
        } else if (user.isNew){
            NSLog(@"Successfully logged in new Facebook user with Parse! %@", user.username);
            [self signUpFacebookUser:user];
        } else {
            NSLog(@"Successfully logged in new Facebook user with Parse! %@", user.username);
            [self logInFacebookUser:user];
        }
    }];
    
    
}

#pragma mark - Helpers

- (void)signUpFacebookUser: (PFUser *)user {
    FBSDKProfile *profile = [FBSDKProfile currentProfile];
    User *newUser = [User new];
    [newUser signUpUser:profile.firstName email:user.email state:@"CA" username:profile.name password:user.username isRepresentative:NO withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with logging in given Facebook user as a Represent User: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully logged in given Facebook user as a Represent User!");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void)logInFacebookUser: (PFUser *)user {
    FBSDKProfile *profile = [FBSDKProfile currentProfile];
    [User logInWithUsernameInBackground:profile.name password:user.username block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with logging in with existing user using Facebook: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully logged in with existing user using Facebook!");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}


- (IBAction)pressedSignUp:(id)sender {
    [self performSegueWithIdentifier:@"signUpSegue" sender:sender];
}




@end

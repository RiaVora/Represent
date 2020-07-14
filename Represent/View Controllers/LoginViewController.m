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

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [Question postUserQuestion:@"test question" forRepresentative:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"Question successfully saved!");
//        } else {
//            NSLog(@"Unable to save question: %@", error.localizedDescription);
//        }
//    }];
//    PFQuery *questionQuery = [Question query];
//    [questionQuery orderByDescending:@"createdAt"];
//    [questionQuery includeKey:@"author"];
//    questionQuery.limit = 20;
//
//    [questionQuery findObjectsInBackgroundWithBlock:^(NSArray<Question *> * _Nullable questions, NSError * _Nullable error) {
//        if (questions) {
//            NSLog(@"Successfully received questions!");
//            for (Question *question in questions) {
//                NSLog(@"this questions asks %@", question.text);
//            }
//        } else {
//            NSLog(@"There was a problem fetching Questions: %@", error.localizedDescription);
//        }
//    }];
    
}

#pragma mark - Actions

- (IBAction)pressedLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    BOOL usernameExists = [Utils checkExists:username :@"Username" :self];
    BOOL passwordExists = [Utils checkExists:password :@"Username" :self];
    
    if (usernameExists && passwordExists) {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %ld", error.code);
                [Utils displayAlertWithOk:@"Error with Logging in" :error.localizedDescription :self];
            } else {
                NSLog(@"User %@ logged in successfully", username);
                self.usernameField.text = @"";
                self.passwordField.text = @"";
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
}
- (IBAction)pressedSignUp:(id)sender {
    [self performSegueWithIdentifier:@"signUpSegue" sender:sender];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginSegue"]) {
        
    } else if ([segue.identifier isEqualToString: @"signUpSegue"]) {
        
    }
}



@end

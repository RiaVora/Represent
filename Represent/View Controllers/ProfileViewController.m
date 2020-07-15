//
//  ProfileViewController.m
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)pressedLogout:(id)sender {
    NSString *username = PFUser.currentUser.username;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error logging out: %@", error.localizedDescription);
        } else {
            [self logoutAlert: username: sender];
        }
    }];
}

- (void)logoutAlert: (NSString *)username :(id)sender {
    NSString *title = [NSString stringWithFormat:@"Logout of %@", username];
    UIAlertController *alert = [Utils makeAlert:title :@"Are you sure you want to logout?"];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"logoutSegue" sender:sender];
    }];
    
    [alert addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{}];
    
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"logoutSegue"]) {
        LoginViewController *loginVC = [segue destinationViewController];
        SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        sceneDelegate.window.rootViewController = loginVC;
    }
}


@end

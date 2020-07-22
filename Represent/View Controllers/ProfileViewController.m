//
//  ProfileViewController.m
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

@end

@implementation ProfileViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkUser];
    [self setUpViews];
    // Do any additional setup after loading the view.
}

- (void)checkUser {
    if (!self.user) {
        self.user = [User currentUser];
    }

}

- (void)setUpViews {
    self.usernameLabel.text = self.user.username;
    [self setProfilePhoto];
    [Utils setPartyLabel:self.user.party:self.partyLabel];
    User *currentUser = [User currentUser];
    if ([self.user.username isEqual:currentUser.username]) {
        NSLog(@"users are equal");
        self.cameraButton.hidden = NO;
        self.cameraButton.layer.cornerRadius = self.cameraButton.frame.size.width / 2;
        self.navigationItem.leftBarButtonItem = self.logoutButton;
    } else {
        self.cameraButton.hidden = YES;
        self.navigationItem.leftBarButtonItem = nil;
    }
    
}

- (void)setProfilePhoto {
    if (self.user.profilePhoto) {
        [self.user.profilePhoto getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error with getting data from Image: %@", error.localizedDescription);
            } else {
                self.profileView.image = [Utils resizeImage:[UIImage imageWithData:data] withSize:(CGSizeMake(200, 200))];
                    self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2;
            }
        }];
    } else {
        NSLog(@"Error, no profile photo set");
    }

}



#pragma mark - Actions

- (IBAction)pressedLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error logging out: %@", error.localizedDescription);
        } else {
            [self logoutAlert: self.user.username: sender];
        }
    }];
}

- (IBAction)pressedCamera:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerController


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = [Utils resizeImage:originalImage withSize:(CGSizeMake(200, 200))];
    
    self.profileView.image = nil;
    self.profileView.image = resizedImage;
    self.user.profilePhoto = [Utils getPFFileFromImage:resizedImage];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully saved image");
        } else {
            NSLog(@"Error saving image: %@", error.localizedDescription);
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Alerts

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

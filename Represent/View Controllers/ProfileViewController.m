//
//  ProfileViewController.m
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "ProfileViewController.h"



@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *partyButton;
@property (weak, nonatomic) IBOutlet UITableView *tableViewParty;

@end

@implementation ProfileViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkUser];
    self.descriptionField.delegate = self;
    [self setUpViews];
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.user fetch];
    [self checkUser];
    [self setUpViews];
}

- (void)checkUser {
    if (!self.user) {
        self.user = [User currentUser];
    }
    if ([self.user.username isEqual:[User currentUser].username]) {
        self.cameraButton.hidden = NO;
        self.cameraButton.layer.cornerRadius = self.cameraButton.frame.size.width / 2;
        self.navigationItem.leftBarButtonItem = self.logoutButton;
        if (!self.user.profileDescription) {
            [self setPlaceholderText:self.descriptionField];
        } else {
            self.descriptionField.text = self.user.profileDescription;
        }
    } else {
        self.cameraButton.hidden = YES;
        [self.partyButton setImage:nil forState:UIControlStateNormal];
        self.partyButton.enabled = NO;
        self.navigationItem.leftBarButtonItem = nil;
        self.descriptionField.editable = NO;
        if (!self.user.profileDescription) {
            self.descriptionField.text = @"No Description Written";
            self.descriptionField.textColor = UIColor.lightGrayColor;
            self.descriptionField.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];

        } else {
            self.descriptionField.text = self.user.profileDescription;
        }
    }

}

- (void)setUpViews {
    self.tableViewParty.delegate = self;
    self.tableViewParty.dataSource = self;
    self.tableViewParty.hidden = YES;
    self.usernameLabel.text = self.user.username;
    [self setProfilePhoto];
    NSLog(@"User's party choice is %@", self.user.party);
    if (!self.user.party) {
        [self.partyButton setTitle:[Utils getPartyAt:0] forState:UIControlStateNormal];
        self.user.party = [Utils getPartyAt:0];
        [self.user saveInBackground];
    } else {
        [Utils setPartyButton:self.user.party:self.partyButton];
    }
    [self hideEditingButtons:YES];
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

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.textColor isEqual: UIColor.lightGrayColor]) {
        textView.text = @"";
        textView.textColor = UIColor.blackColor;
        textView.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    }
    [self hideEditingButtons:NO];
    return true;
}
- (void)setPlaceholderText: (UITextView *)textView {
    textView.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    textView.text = @"Tell everyone a little bit about yourself...";
    textView.textColor = UIColor.lightGrayColor;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleCell"];
    }
    cell.textLabel.text = [Utils getPartyAt:(int)indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Utils getPartyLength];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [Utils setPartyButton:cell.textLabel.text :self.partyButton];
    self.user.party = cell.textLabel.text;
    self.tableViewParty.hidden = YES;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"Error with saving user's party!: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully saved user's party choice!");
        }
    }];
}

#pragma mark - Actions

- (IBAction)pressedSave:(id)sender {
    [self.descriptionField resignFirstResponder];
    if ([self.descriptionField.text isEqualToString:@""]) {
        [self setPlaceholderText:self.descriptionField];
    }
    
    self.user.profileDescription = self.descriptionField.text;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"Error with saving description!: %@", error.localizedDescription);
        } else {
            NSLog(@"User successfully saved!");
            [self hideEditingButtons:YES];
            [self viewDidLoad];
        }
    }];
}

- (IBAction)pressedCancel:(id)sender {
    [self.descriptionField resignFirstResponder];
    if ([self.descriptionField.text isEqualToString:@""]) {
        [self setPlaceholderText:self.descriptionField];
    } else {
        self.descriptionField.text = self.user.profileDescription;
    }
    
    [self hideEditingButtons:YES];
    [self viewDidLoad];
}

- (IBAction)pressedParty:(id)sender {
    self.tableViewParty.hidden = !(self.tableViewParty.hidden);

}

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

- (void)hideEditingButtons: (BOOL)hide {
    self.saveButton.hidden = hide;
    self.cancelButton.hidden = hide;
}


@end

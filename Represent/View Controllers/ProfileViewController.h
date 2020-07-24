//
//  ProfileViewController.h
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Utils.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>;

/*The ProfileViewController is a UIViewController class that is used to display the profile of the currently logged-in user. The page consists of a main view that displays the User's information (such as party, description, username) and allows the User to log out and contact a representative.*/

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property User *user;

@end

NS_ASSUME_NONNULL_END

//
//  ContactViewController.h
//  Represent
//
//  Created by Ria Vora on 7/30/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "RepresentativeCell.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "WebKit/WebKit.h"

/*The ContactViewController is a UIViewController class consisting of a dropdown menu and a WebKitView to display the contact form of the representative. The contact form is used to send a message to a representative, and the ContactViewController, is called from the "Contact" bar button in the ProfileViewController.*/

NS_ASSUME_NONNULL_BEGIN

@interface ContactViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

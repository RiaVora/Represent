//
//  Utils.h
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import <Parse/Parse.h>

/*The Utils file is a NSObject class that is used to collect helper methods to be used across classes. The Utils method contains various types of methods for displaying Alerts on ViewControllers and creating custom alerts, as well as converting an Image into a PFFFile for transfer into Parse and resizing the image.*/

NS_ASSUME_NONNULL_BEGIN

@class User;

@interface Utils : NSObject

/*Returns whether the text is not empty, and creates and displays an alert if the given text does not exist.*/
+ (BOOL)checkExists:(NSString *)text :(NSString *)field :(UIViewController *)viewController;

/*Returns whether text1 is equal to text2, and creates and displays an alert if they are not equal.*/
+ (BOOL)checkEquals:(NSString *)text1 :(NSString *)text2 :(NSString *)field :(UIViewController *)viewController;

/*Returns whether the text is a certain length, and creates and displays an alert if the text is not the given length*/
+ (BOOL)checkLength:(NSString *)text :(NSNumber *)length :(NSString *)field :(UIViewController *)viewController;

/*Creates and displays an alert with the given title and message, and only an OK button*/
+ (void)displayAlertWithOk:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController;

/*Creates and returns an alert with the given title and message.*/
+ (UIAlertController *)makeAlert:(NSString *)title :(NSString *)message;

/*Creates and returns a bottom alert with the given title and message.*/
+ (UIAlertController *)makeBottomAlert:(NSString *)title :(NSString *)message;

/*Returns the PPFileObject version of the given UIImage for saving on Parse.*/
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

/*Returns a UIImage resized to the given CGSize.*/
+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

/*Sets a label indicating a bill's result to the correct color and text.*/
+ (void)setResultLabel: (NSString *)resultString forLabel:(UILabel *)label;

/*Sets a button indicating a user's party to the correct color and text.*/
+ (void)setPartyButton: (NSString *)partyString :(UIButton *)button;

/*Sets a label indicating a user's party to the correct color and text.*/
+ (void)setPartyLabel: (NSString *)partyString :(UILabel *)label;

/*Returns a party given an index, used for a dropdown menu in the ProfileViewController.*/
+ (NSString *)getPartyAt: (int)index;

/*Returns the number of parties, used for a dropdown menu in the ProfileViewController.*/
+ (NSInteger)getPartyLength;

@end

NS_ASSUME_NONNULL_END

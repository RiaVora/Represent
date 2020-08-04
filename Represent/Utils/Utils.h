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

/*METHODS*/

/*Returns whether the text is not empty, and creates and displays an alert if the given text does not exist.
 
 @param text is the text from the user input (the method checks if it is empty)
 @param field is the name of the field to display in the alert
 @param viewController is the view controller to display the alert on
 @return YES if the text is empty; NO otherwise
 */
+ (BOOL)checkExists:(NSString *)text :(NSString *)field :(UIViewController *)viewController;

/*Returns whether text1 is equal to text2, and creates and displays an alert if they are not equal.
 
 @param text1 is the text from the user input
 @param text2 is the text that text1 should be equal to
 @param field is the name of the field to display in the alert
 @param viewController is the view controller to display the alert on
 @return YES if text1 is equal to text2; NO otherwise
 */
+ (BOOL)checkEquals:(NSString *)text1 :(NSString *)text2 :(NSString *)field :(UIViewController *)viewController;

/*Returns whether the text is a certain length, and creates and displays an alert if the text is not the given length
 
 @param text is the text from the user input (the method checks length)
 @param length is the desired length of the text
 @param field is the name of the field to display in the alert
 @param viewController is the view controller to display the alert on
 @return YES if text's length is length; NO otherwise
 */
+ (BOOL)checkLength:(NSString *)text :(NSNumber *)length :(NSString *)field :(UIViewController *)viewController;

/*Creates and displays an alert with the given title and message, and only an OK button
 
 @param title is the title to display in the alert
 @param messsage is the message to display in the alert
 @param viewController is the view controller to display the alert on
 */
+ (void)displayAlertWithOk:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController;

/*Creates and returns an alert with the given title and message.
 
 @param title is the title to display in the alert
 @param messsage is the message to display in the alert
 @return an instance of UIAlertController with the given title and message
 */
+ (UIAlertController *)makeAlert:(NSString *)title :(NSString *)message;

/*Creates and returns a bottom alert with the given title and message.
 
 @param title is the title to display in the alert
 @param messsage is the message to display in the alert
 @return an instance of a UIAlertController with style bottom and the given title and message
 */
+ (UIAlertController *)makeBottomAlert:(NSString *)title :(NSString *)message;

/*Returns the PPFileObject version of the given UIImage for saving on Parse.
 
 @param image is the image to get the PFFile from
 @return a PFFileObject containing the details of image
 */
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

/*Returns a UIImage resized to the given CGSize.
 
 @param image is the image to be resized
 @param a CGSize with height and width of what the image should be resized too
 @return a UIImage of image with the given size
 */
+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

/*Sets a label indicating a bill's result to the correct color and text.
 
 @param resultString is the result from the bill object
 @param label is the UILabel to display the formatted result on
 */
+ (void)setResultLabel: (NSString *)resultString forLabel:(UILabel *)label;

/*Sets a button indicating a user's party to the correct color and text.
 
 @param partyString is the party from the User object
 @param button is the UIButton to display the formatted result on
 */
+ (void)setPartyButton: (NSString *)partyString :(UIButton *)button;

/*Sets a label indicating a user's party to the correct color and text.
 
 @param partyString is the party from the User object
 @param label is the UILabel to display the formatted result on
 */
+ (void)setPartyLabel: (NSString *)partyString :(UILabel *)label;

/*Returns a party given an index, used for a dropdown menu in the ProfileViewController.
 
 @param index of party array
 @return the party at the given index
 */
+ (NSString *)getPartyAt: (int)index;

/*Returns the number of parties, used for a dropdown menu in the ProfileViewController.
 
 @return the length of the party array (how many parties there are)
 */
+ (NSInteger)getPartyLength;

/*Returns a filter given an index, used for a dropdown filter menu in the BillsViewController.
 
 @param index of filter array
 @return the filter at the given index
 */
+ (NSString *)getFilterAt: (int)index;

/*Returns the number of filters, used for a dropdown filter menu in the BillsViewController.
 
 @return the length of the filter array (how many filters there are)
*/
+ (NSInteger)getFilterLength;

/*Returns whether the value in a dictionary exists by checking for both [NSNull null] and nil
 
 @param dictionary is the given dictionary to check
 @param key is the given key to check on the dictionary
 @return YES if the value of the dictionary with the given key is not null; NO otherwise
*/
+ (BOOL)valueExists: (NSDictionary *)dictionary forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

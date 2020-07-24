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

+ (BOOL)checkExists:(NSString *)text :(NSString *)field :(UIViewController *)viewController;
+ (BOOL)checkEquals:(NSString *)text1 :(NSString *)text2 :(NSString *)field :(UIViewController *)viewController;
+ (BOOL)checkLength:(NSString *)text :(NSNumber *)length :(NSString *)field :(UIViewController *)viewController;
+ (void)displayAlertWithOk:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController;
+ (UIAlertController *)makeAlert:(NSString *)title :(NSString *)message;
+ (UIAlertController *)makeBottomAlert:(NSString *)title :(NSString *)message;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;
+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;
+ (void)setResultLabel: (NSString *)resultString forLabel:(UILabel *)label;
+ (void)setPartyButton: (NSString *)partyString :(UIButton *)button;
+ (NSString *)getPartyAt: (int)index;
+ (NSInteger)getPartyLength;

@end

NS_ASSUME_NONNULL_END

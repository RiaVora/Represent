//
//  Utils.h
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+ (BOOL)checkExists:(NSString *)text :(NSString *)field :(UIViewController *)viewController;
+ (BOOL)checkEquals:(NSString *)text1 :(NSString *)text2 :(NSString *)field :(UIViewController *)viewController;
+ (BOOL)checkLength:(NSString *)text :(NSNumber *)length :(NSString *)field :(UIViewController *)viewController;
+ (void)displayAlertWithOk:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController;
+ (UIAlertController *)makeAlert:(NSString *)title :(NSString *)message;

@end

NS_ASSUME_NONNULL_END

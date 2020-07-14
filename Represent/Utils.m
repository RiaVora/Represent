//
//  Utils.m
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (BOOL)checkExists:(NSString *)text :(NSString *)field :(UIViewController *)viewController {
    if ([text isEqual:@""]) {
        [self displayAlertWithOk: [NSString stringWithFormat: @"%@ Cannot Be Blank", field]: [NSString stringWithFormat: @"Please create a %@.", field]: viewController];
        return NO;
    }
    return YES;
}

+ (void)displayAlertWithOk:(NSString *)title :(NSString *)message :(UIViewController *)viewController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:okAction];
    
    [viewController presentViewController:alert animated:YES completion:^{}];
}

+ (UIAlertController *)makeAlert:(NSString *)title :(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    return alert;
    
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                     handler:^(UIAlertAction * _Nonnull action) {}];
//
//    [alert addAction:okAction];
//
//    [viewController presentViewController:alert animated:YES completion:^{}];
}

@end

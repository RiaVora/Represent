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
+ (void)displayAlertWithOk:(NSString *)title :(NSString *)message :(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END

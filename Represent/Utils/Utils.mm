//
//  Utils.m
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "Utils.h"

static const NSArray *passed = [NSArray arrayWithObjects: @"Passed", @"Agreed to", @"Amendment Agreed to", @"Nomination Confirmed", @"Bill Passed", @"Cloture Motion Agreed to", @"Motion Agreed to", @"Motion to Proceed Agreed to", @"Motion to Table Agreed to", @"Cloture on the Motion to Proceed Agreed to", nil];
static const NSArray *failed = [NSArray arrayWithObjects: @"Failed", @"Amendment Rejected", @"Cloture Motion Rejected", @"Motion Rejected", @"Motion to Proceed Rejected", @"Motion to Table Rejected", @"Cloture on the Motion to Proceed Rejected", @"Bill Failed", @"Veto Sustained", @"Motion Rejected", nil];
static const NSArray *parties = [NSArray arrayWithObjects: @"No Party Chosen", @"Democrat", @"Republican", @"Independent", @"Non-Affiliated", nil];
static const NSArray *filters = [NSArray arrayWithObjects: @"Senate", @"House", @"Passed", @"Failed", nil];
NSInteger const topQuestionsLimit = 3;


@implementation Utils

#pragma mark - Alerts

+ (BOOL)checkExists:(NSString *)text :(NSString *)field :(UIViewController *)viewController {
    if ([text isEqual:@""]) {
        [self displayAlertWithOk:[NSString stringWithFormat: @"%@ Cannot Be Blank", field] message:[NSString stringWithFormat: @"Please create a %@.", field] viewController:viewController];
        return NO;
    }
    return YES;
}

+ (BOOL)checkEquals:(NSString *)text1 :(NSString *)text2 :(NSString *)field :(UIViewController *)viewController {
    if (![text1 isEqual:text2]) {
        [self displayAlertWithOk:@"Not Equal" message:field viewController:viewController];
        return NO;
    }
    return YES;
}

+ (BOOL)checkLength:(NSString *)text :(NSNumber *)length :(NSString *)field :(UIViewController *)viewController {
    NSNumber *currentLength = [NSNumber numberWithLong:text.length];
    if (![currentLength isEqualToNumber:length]){
        [self displayAlertWithOk:[NSString stringWithFormat: @"Incorrect %@", field] message:[NSString stringWithFormat: @"%@ should be %@ letters long", field, length] viewController:viewController];
        return NO;
    }
    return YES;
}

+ (void)displayAlertWithOk:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [viewController presentViewController:alert animated:YES completion:^{}];
}

+ (UIAlertController *)makeAlert:(NSString *)title :(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    return alert;
}

+ (UIAlertController *)makeBottomAlert:(NSString *)title :(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    return alert;
}

#pragma mark - Image/Data

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }

    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;

    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Labels/Buttons

+ (void)setResultLabel: (NSString *)resultString forLabel:(UILabel *)label {
    label.text = resultString;
    if ([self passed:resultString]) {
        label.textColor = UIColor.systemGreenColor;
    } else if (![self passed:resultString]) {
        label.textColor = UIColor.systemRedColor;
    } else {
        label.textColor = UIColor.systemBlueColor;
    }
}

+ (BOOL)passed: (NSString *)resultString {
    if ([passed containsObject:resultString] || [resultString containsString:@"Passed"] || [resultString containsString:@"Agreed to"]) {
        return YES;
    } else if ([failed containsObject:resultString] || [resultString containsString:@"Failed"] || [resultString containsString: @"Rejected"]) {
        return NO;
    } else {
        return nil;
    }
}

+ (void)setPartyButton: (NSString *)partyString :(UIButton *)button{
    if ([partyString.uppercaseString isEqualToString:@"DEMOCRAT"] || [partyString.uppercaseString isEqualToString:@"D"]) {
        [button setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
        partyString = @"Democrat";
    } else if ([partyString.uppercaseString isEqualToString:@"REPUBLICAN"] || [partyString.uppercaseString isEqualToString:@"R"]) {
        [button setTitleColor:UIColor.systemRedColor forState:UIControlStateNormal];
        partyString = @"Republican";
    } else if ([partyString.uppercaseString isEqualToString:@"INDEPENDENT"] || [partyString.uppercaseString isEqualToString:@"ID"] || [partyString.uppercaseString isEqualToString:@"I"]) {
        partyString = @"Independent";
        [button setTitleColor:UIColor.systemPurpleColor forState:UIControlStateNormal];
    } else {
        [button setTitleColor:UIColor.systemGrayColor forState:UIControlStateNormal];
        partyString = @"Non-Affiliated";
    }
    [button setTitle:partyString forState:UIControlStateNormal];
}

+ (void)setPartyLabel: (NSString *)partyString :(UILabel *)label{
    if ([partyString.uppercaseString isEqualToString:@"DEMOCRAT"] || [partyString.uppercaseString isEqualToString:@"D"]) {
        label.textColor = UIColor.systemBlueColor;
        partyString = @"Democrat";
    } else if ([partyString.uppercaseString isEqualToString:@"REPUBLICAN"] || [partyString.uppercaseString isEqualToString:@"R"]) {
        label.textColor = UIColor.systemRedColor;
        partyString = @"Republican";
    } else if ([partyString.uppercaseString isEqualToString:@"INDEPENDENT"] || [partyString.uppercaseString isEqualToString:@"ID"] || [partyString.uppercaseString isEqualToString:@"I"]) {
        label.textColor = UIColor.systemPurpleColor;
        partyString = @"Independent";
    } else {
        label.textColor = UIColor.systemGrayColor;
        partyString = @"Non-Affiliated";
    }
    label.text = partyString;
}

#pragma mark - Constants

+ (NSString *)getPartyAt: (int)index {
    return parties[index];
}

+ (NSInteger)getPartyLength {
    return parties.count;
}

+ (NSString *)getFilterAt: (int)index {
    return filters[index];
}

+ (NSInteger)getFilterLength {
    return filters.count;
}

+ (NSInteger)getLimit {
    return topQuestionsLimit;
}

#pragma mark - Helpers

+ (BOOL)valueExists: (NSDictionary *)dictionary forKey:(NSString *)key {
    return ([dictionary objectForKey:key] != nil && [dictionary objectForKey:key] != [NSNull null]);
}

@end

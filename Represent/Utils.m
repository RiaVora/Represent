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

@end

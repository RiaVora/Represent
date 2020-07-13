//
//  User.m
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic firstName;
@dynamic description;
@dynamic party;
@dynamic followedRepresentatives;
@dynamic zipcode;
@dynamic profilePhoto;
@dynamic isRepresentative;
@dynamic position;



- (void)signUpUser {
    [self signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Success in signing up user");
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"profile-photo.png" data:imageData];
}

@end

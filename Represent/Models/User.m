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
@dynamic profileDescription;
@dynamic party;
@dynamic followedRepresentatives;
@dynamic zipcode;
@dynamic profilePhoto;
@dynamic isRepresentative;
@dynamic position;


+(User*)user {
    return (User*)[PFUser user];
}

- (void)signUpUser: (NSString *)firstName email:(NSString *)email zipcode:(NSString *)zipcode username:(NSString *)username password:(NSString *)password withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    self.firstName = firstName;
    self.email = email;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    self.zipcode = [formatter numberFromString:zipcode];
    self.username = username;
    self.password = password;
    [self signUpInBackgroundWithBlock: completion];
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

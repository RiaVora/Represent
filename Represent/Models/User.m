//
//  User.m
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "User.h"
#import "APIManager.h"

@implementation User

@dynamic firstName;
@dynamic profileDescription;
@dynamic party;
@dynamic followedRepresentatives;
@dynamic state;
@dynamic profilePhoto;
@dynamic isRepresentative;
@dynamic position;
@dynamic short_position;
@dynamic contact;


+(User*)user {
    return (User*)[PFUser user];
}

- (void)signUpUser: (NSString *)firstName email:(NSString *)email state:(NSString *)state username:(NSString *)username password:(NSString *)password isRepresentative:(BOOL)isRepresentative withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    self.firstName = firstName;
    self.isRepresentative = isRepresentative;
    self.state = state.uppercaseString;
    self.username = username;
    self.password = password;
    self.followedRepresentatives = [[NSMutableArray alloc] init];
    if (!isRepresentative) {
        self.email = email;
        [self getRepresentatives];
    }
    [self signUpInBackgroundWithBlock: completion];
}

- (void)getRepresentatives {
//    NSString *state = self.state;
//    APIManager *manager = [APIManager new];
//    [manager fetchLocalReps:state :^(NSArray * _Nonnull representatives, NSError * _Nonnull error) {
//        if (error) {
//            NSLog(@"Error with adding representatives to user: %@", error.localizedDescription);
//        } else {
//            NSLog(@"Success with finding representatives for user %@!", self.username);
//
//            for (NSDictionary *representative in representatives) {
//                [self addRepresentative:representative state:state];
//            }
//            NSLog(@"%lu representatives added to user %@!", (unsigned long)representatives.count, self.username);
//        }
//    }];
}

- (void)addRepresentative: (NSDictionary *)representative state:(NSString *)state {
//    User *user = [User representativeExists:representative[@"name"]];
//    if (!user) {
//        user = [User new];
//        [user signUpRepresentative:representative state:state];
//    }
//    [self addObject:user forKey:@"followedRepresentatives"];
//    [self saveInBackground];
}

+ (void) signUpRepresentative: (NSDictionary *)representative {
    User *user = [User new];
    user.position = representative[@"title"];
    user.short_position = representative[@"short_title"];
    user.party = representative[@"party"];
    user.contact = representative[@"contact_form"];
    [user signUpUser:representative[@"first_name"] email:@"" state:representative[@"state"] username:representative[@"id"] password:representative[@"date_of_birth"] isRepresentative:YES withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error adding representative: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully added Representative %@", user.username);
        }
    }];
}
                  
+ (User *)findRepresentatives :(NSString *)state{
    User __block *user = nil;
    PFQuery *userQuery = [User query];
    [userQuery whereKey:@"state" matchesText:state];
//    [userQuery whereKey:@"isRepresentative" equalTo:YES];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray <User *>* _Nullable users, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with fetching Users to check if representatives exist: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched Users to check if representatives exist!");
            if (users.count == 1) {
                user = users[0];
                NSLog(@"Found one user");
            } else if (users.count > 1) {
                NSLog(@"Returned more than one user, not possible");
            }
        }
    }];
    return user;
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

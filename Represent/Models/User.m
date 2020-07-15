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
    self.profilePhoto = [Utils getPFFileFromImage: [UIImage imageNamed:@"profile_tab"]];
    self.followedRepresentatives = [[NSMutableArray alloc] init];
    if (!isRepresentative) {
        self.email = email;
        [self getRepresentatives];
    }
    [self signUpInBackgroundWithBlock: completion];
}

- (void)getRepresentatives {
    NSString *state = self.state;
    PFQuery *userQuery = [User query];
    [userQuery whereKey:@"state" matchesText:state];
    [userQuery whereKey:@"isRepresentative" equalTo:@(YES)];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray <User *>* _Nullable users, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with fetching representatives: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched Users to check if representatives exist!");
            for (User *user in users) {
                [self addObject:user forKey:@"followedRepresentatives"];
            }
        }
    }];
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


@end

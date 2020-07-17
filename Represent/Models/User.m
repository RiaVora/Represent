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
@dynamic shortPosition;
@dynamic contact;
@dynamic lastName;
@dynamic votedQuestions;


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
    self.votedQuestions = [[NSMutableArray alloc] init];
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
    user.shortPosition = representative[@"short_title"];
    user.party = representative[@"party"];
    user.contact = representative[@"contact_form"];
    user.lastName = representative[@"last_name"];
    [user signUpUser:representative[@"first_name"] email:@"" state:representative[@"state"] username:representative[@"id"] password:representative[@"date_of_birth"] isRepresentative:YES withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error adding representative: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully added Representative %@", user.username);
        }
    }];
}

- (NSString *)fullTitleRepresentative {
    if (self.isRepresentative) {
        return [NSString stringWithFormat:@"%@ %@ %@", self.shortPosition, self.firstName, self.lastName];
    } else {
        return @"Not a representative";
    }
}

- (BOOL)voteOnQuestion:(Question *)newQuestion {
    PFQuery *questionQuery = [Question query];
//    NSLog(@"Question object ID is %@", newQuestion.objectId);
    [questionQuery whereKey:@"objectId" equalTo:newQuestion.objectId];
//    dispatch_group_enter(taskGroup);
    NSArray *questionsFound = [questionQuery findObjects];
    if (questionsFound.count == 0) {
        if (!self.votedQuestions) {
            self.votedQuestions = [[NSMutableArray alloc] init];
        }
        [self addObject:newQuestion forKey:@"votedQuestions"];
        [self saveInBackground];
        return YES;
    } else {
        return NO;
    }
}

@end

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
@dynamic lastVoted;
@dynamic availableVoteCount;

#pragma mark - Init

+(User*)user {
    return (User*)[PFUser user];
}

#pragma mark - Setup

- (void)signUpUser: (NSString *)firstName email:(NSString *)email state:(NSString *)state username:(NSString *)username password:(NSString *)password isRepresentative:(BOOL)isRepresentative withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    self.firstName = firstName;
    self.isRepresentative = isRepresentative;
    self.state = state.uppercaseString;
    self.username = username;
    self.password = password;
    self.profilePhoto = [Utils getPFFileFromImage: [UIImage imageNamed:@"profile_tab"]];
    self.followedRepresentatives = [[NSMutableArray alloc] init];
    self.votedQuestions = [[NSMutableArray alloc] init];
    self.availableVoteCount = [NSNumber numberWithInt:5];
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
    user.objectId = representative[@"id"];
    [user signUpUser:representative[@"first_name"] email:@"" state:representative[@"state"] username:representative[@"id"] password:representative[@"date_of_birth"] isRepresentative:YES withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error adding representative: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully added Representative %@", user.username);
        }
    }];
}

#pragma mark - Actions


- (BOOL)voteOnQuestion:(Question *)newQuestion {
    BOOL hasVoted = [self hasVoted:newQuestion];
    if (hasVoted) {
        [self removeObject:newQuestion forKey:@"votedQuestions"];
        [self incrementKey:@"availableVoteCount" byAmount:[NSNumber numberWithInt:1]];
    } else {
        if (!self.votedQuestions) {
            self.votedQuestions = [[NSMutableArray alloc] init];
        }
        [self addObject:newQuestion forKey:@"votedQuestions"];
        [self incrementKey:@"availableVoteCount" byAmount:[NSNumber numberWithInt:-1]];
        [self setObject:[NSDate date] forKey:@"lastVoted"];
    }
    [self saveInBackground];
    return !hasVoted;
}

#pragma mark - Helpers

- (NSString *)fullTitleRepresentative {
    if (self.isRepresentative) {
        return [NSString stringWithFormat:@"%@ %@ %@", self.shortPosition, self.firstName, self.lastName];
    } else {
        return @"Not a representative";
    }
}

- (BOOL)hasVoted:(Question *)newQuestion {
    for (Question *question in self.votedQuestions) {
        if ([question.objectId isEqualToString:newQuestion.objectId]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)votesLeft {
    return [self.availableVoteCount intValue] > 0;
}

- (void)updateAvailableVotes {
    NSDate *now = [NSDate date];
    if (!self.lastVoted || ![[NSCalendar currentCalendar] isDate:now inSameDayAsDate:self.lastVoted]) {
        self.availableVoteCount = [NSNumber numberWithInt:5];
        [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!succeeded) {
                NSLog(@"Error with refreshing available votes %@", error.localizedDescription);
            } else {
                NSLog(@"Success with refreshing available votes!");
            }
         }];
    }
}

@end

//
//  Bill.m
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "Bill.h"
#import "DateTools.h"

@implementation Bill

@dynamic billID;
@dynamic type;
@dynamic sponsor;
@dynamic title;
@dynamic shortSummary;
@dynamic date;
@dynamic question;
@dynamic result;
@dynamic votesFor;
@dynamic votesAgainst;
@dynamic votesAbstain;
@dynamic headBill;
@dynamic committee;
@dynamic forDescription;
@dynamic againstDescription;
@dynamic billURL;


#pragma mark - Init
+ (nonnull NSString *)parseClassName {
    return @"Bill";
}

#pragma mark - Setup

+ (void) updateBills: (NSDictionary *)dictionary withCompletion:(void(^)(BOOL isDuplicate, Bill *bill))completion {
    Bill *bill = [Bill new];
    if ([Utils valueExists:dictionary[@"bill"] forKey:@"bill_id"]) {
        [bill setUpBill:dictionary[@"bill"]];
    } else if ([Utils valueExists:dictionary[@"nomination"] forKey:@"nomination_id"]) {
        [bill setUpNomination:dictionary[@"nomination"]:dictionary];
    } else {
        NSLog(@"THIS BILL IS NOT A NOMINATION OR BILL");
    }
    bill.date = [Bill formatDate:dictionary[@"date"] :dictionary[@"time"]];
    BOOL isDuplicate = [bill setHeadBill];
    if (!isDuplicate) {
        [bill setUpValues:dictionary];
        [bill setUpVotes:dictionary[@"vote_uri"] withCompletion:^(BOOL complete) {
            if (complete) {
                [bill saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        NSLog(@"Bill %@ successfully saved", bill.billID);
                        completion(NO, bill);
                    } else {
                        completion(NO, nil);
                    }
                }];
            } else {
                completion(NO, nil);
            }
        }];
    } else {
        completion(YES, bill);
    }
}


- (void)setUpBill: (NSDictionary *)billDictionary {
    self.billID = billDictionary[@"bill_id"];
    self.shortSummary = billDictionary[@"title"];
}

- (void)setUpNomination: (NSDictionary *)nominationDictionary :(NSDictionary *)dictionary {
    self.billID = nominationDictionary[@"nomination_id"];
}

- (void)setUpValues:(NSDictionary *)dictionary {
    self.votesFor = [[NSMutableArray alloc] init];
    self.votesAgainst = [[NSMutableArray alloc] init];
    self.votesAbstain = [[NSMutableArray alloc] init];
    self.question = dictionary[@"question"];
    if ([Utils valueExists:dictionary[@"bill"] forKey:@"bill_id"]) {
        self.billURL = [dictionary[@"bill"] objectForKey:@"api_uri"];
        if ([Utils valueExists:dictionary[@"bill"] forKey:@"sponsor_id"]) {
            NSLog(@"sponsorID is %@", dictionary[@"bill"][@"sponsor_id"]);
            [self findSponsor:[dictionary[@"bill"] objectForKey:@"sponsor_id"]];
        }
    }
    
    self.type = dictionary[@"chamber"];
    self.title = dictionary[@"description"];
    self.result = dictionary[@"result"];
}



- (void)setUpVotes: (NSString *)votesURL withCompletion:(void(^)(BOOL complete))completion {
    APIManager *manager = [APIManager new];
    [manager fetchVotes:votesURL :^(NSArray * _Nonnull votes, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error with fetching votes from API");
            completion(FALSE);
            
        } else {
            NSLog(@"Success with fetching votes from API!");
            [self addVotes:votes];
            completion(TRUE);
        }
    }];
}

- (void)addVotes: (NSArray *)votes {
    NSArray *votesFor = [votes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"(vote_position==%@)", @"Yes"]];
    NSArray *votesAgainst = [votes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"(vote_position==%@)", @"No"]];
    NSArray *votesAbstain = [votes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"(vote_position contains[c] %@)", @"Not"]];
    [self addObjectsFromArray:votesFor forKey:@"votesFor"];
    [self addObjectsFromArray:votesAgainst forKey:@"votesAgainst"];
    [self addObjectsFromArray:votesAbstain forKey:@"votesAbstain"];
    
}

- (void)findSponsor:(NSString *)sponsorID {
    PFQuery *userQuery = [User query];
    [userQuery whereKey:@"representativeID" equalTo:sponsorID];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with finding representative user with sponsorId: %@", error.localizedDescription);
        } else {
            if (users.count == 0) {
                NSLog(@"Did not find representative associated with that sponsorId");
            } else if (users.count == 1){
                NSLog(@"Found representative user with sponsorId!");
                self.sponsor = users[0];
            } else {
                NSLog(@"Found more than one user with sponsorId! %@", users);
            }
        }
    }];
}

+ (NSDate *)formatDate:(NSString *)dateString :(NSString *)timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd-HH:mm:ss";
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat: @"%@-%@", dateString, timeString]];
    return date;
}

- (BOOL)setHeadBill {
    PFQuery *billQuery = [PFQuery queryWithClassName:@"Bill"];
    [billQuery whereKey:@"billID" equalTo:self.billID];
    [billQuery orderByDescending:@"date"];
    
    NSArray *bills = [billQuery findObjects];
    if (bills.count > 0) {
        for (Bill *oldBill in bills) {
            if ([self.date isEqualToDate:oldBill.date]) {
                [self setValue:@(NO) forKey:@"headBill"];
                return YES;
            } else if (oldBill[@"headBill"] && ([self.date minutesFrom:oldBill.date] > 0)) {
                [oldBill setValue:@(NO) forKey:@"headBill"];
                [oldBill save];
                [self setValue:@(YES) forKey:@"headBill"];
                return NO;
            }
        }
        [self setValue:@(NO) forKey:@"headBill"];
        return NO;
    } else {
        [self setValue:@(YES) forKey:@"headBill"];
        return NO;
    }
}

#pragma mark - References

- (NSString *)voteOfRepresentative: (NSString *)repID {
    if ([self repVotedFor:repID]) {
        return @"Yes";
    } else if ([self repVotedAgainst:repID]) {
        return @"No";
    }
    //    else if ([self repDidNotVote:repID]) {
    //        return @"Abstain";
    //    }
    else {
        //        NSLog(@"No vote found for rep of ID %@ for bill %@", repID, self.title);
        return @"No Vote Found";
    }
}

#pragma mark - Helpers

- (BOOL)repVotedFor:(NSString *)repID {
    return [self repVoted: self.votesFor forRep:repID];
}

- (BOOL)repVotedAgainst:(NSString *)repID {
    return [self repVoted: self.votesAgainst forRep:repID];
}

- (BOOL)repVoted: (NSArray *)arrayOfVotes forRep:(NSString *)repID {
    NSArray *vote = [arrayOfVotes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(member_id ==[c]%@)", repID]];
    if (vote.count > 0) {
        return YES;
    } else if (vote.count > 1) {
        NSLog(@"Error unknown, there are mutliple members for a single vote call. Rep id is %@, bill is %@, duplicate votes are %@", repID, self.title, vote);
        return YES;
    } else {
        return NO;
    }
}

@end

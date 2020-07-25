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
@dynamic number;
@dynamic type;
@dynamic sponsor;
@dynamic title;
@dynamic shortSummary;
@dynamic longSummary;
@dynamic date;
@dynamic question;
@dynamic result;
@dynamic votesFor;
@dynamic votesAgainst;
@dynamic votesAbstain;
@dynamic headBill;
@dynamic votesURL;
@dynamic committee;
@dynamic forDescription;
@dynamic againstDescription;


#pragma mark - Init
+ (nonnull NSString *)parseClassName {
    return @"Bill";
}

#pragma mark - Setup

+ (Bill *) updateBills: (NSDictionary *)dictionary {
    Bill *bill = [Bill new];
    if (dictionary[@"bill"][@"bill_id"]) {
        [bill setUpBill:dictionary[@"bill"]:dictionary];
    } else if (dictionary[@"nomination"][@"nomination_id"]) {
        [bill setUpNomination:dictionary[@"nomination"]:dictionary];
    } else {
        NSLog(@"THIS BILL IS NOT A NOMINATION OR BILL");
    }
    bill.date = [Bill formatDate:dictionary[@"date"] :dictionary[@"time"]];
    BOOL isDuplicate = [bill setHeadBill];
    if (!isDuplicate) {
        [bill setUpValues:dictionary];
        [bill save];
    }
    return bill;
}

- (void)setUpBill: (NSDictionary *)billDictionary :(NSDictionary *)dictionary {
    self.billID = billDictionary[@"bill_id"];
    self.number = billDictionary[@"number"];
    [self findSponsor:billDictionary[@"sponsor_id"]];
    self.shortSummary = billDictionary[@"title"];
    self.question = dictionary[@"question"];
}

- (void)setUpNomination: (NSDictionary *)nominationDictionary :(NSDictionary *)dictionary {
    self.billID = nominationDictionary[@"nomination_id"];
    self.number = nominationDictionary[@"number"];
}

- (void)setUpValues:(NSDictionary *)dictionary {
    self.type = dictionary[@"chamber"];
    self.title = dictionary[@"description"];
    self.result = dictionary[@"result"];
    self.votesURL = dictionary[@"vote_uri"];
    self.votesFor = [[NSMutableArray alloc] init];
    self.votesAgainst = [[NSMutableArray alloc] init];
    self.votesAbstain = [[NSMutableArray alloc] init];
    [self setUpVotes];
}

- (void)setUpVotes {
    APIManager *manager = [APIManager new];
    [manager fetchVotes:self.votesURL :^(NSArray * _Nonnull votes, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error with fetching votes from API");
        } else {
            NSLog(@"Success with fetching votes from API!");
            [self addVotes: votes];
        }
    }];
}

- (void)addVotes: (NSArray *)votes {
    PFQuery *userQuery = [User query];
    [userQuery whereKey:@"isRepresentative" equalTo:@(YES)];
    if ([self.type isEqualToString:@"Senate"]) {
        [userQuery whereKey:@"shortPosition" equalTo:@"Sen."];
    } else {
        [userQuery whereKey:@"shortPosition" equalTo:@"Rep."];
    }
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable reps, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with finding reps that voted on the bill %@: %@", self.title, error.localizedDescription);
        } else {
            NSLog(@"the number of reps found is %@", reps.count);
            for (User *rep in reps) {
                NSArray *repVote = [votes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(member_id ==[c]%@)", rep.representativeID]];
                if (repVote.count == 0) {
//                    NSLog(@"Representative %@ vote not found for bill %@", [rep fullTitleRepresentative], self.title);
                } else if ([repVote[0][@"vote_position"] isEqualToString: @"Yes"]) {
                    [self addObject:rep forKey:@"votesFor"];
                } else if ([repVote[0][@"vote_position"] isEqualToString: @"No"]) {
                    [self addObject:rep forKey:@"votesAgainst"];
                } else {
                    [self addObject:rep forKey:@"votesAbstain"];
                }
            }

            [self saveInBackground];
        }
    }];
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

- (NSString *)voteOfRepresentative: (NSString *)repID {
    if ([self repVotedFor:repID]) {
        return @"Yes";
    } else if ([self repVotedAgainst:repID]) {
        return @"No";
    } else if ([self repDidNotVote:repID]) {
        return @"Abstain";
    } else {
//        NSLog(@"No vote found for rep of ID %@ for bill %@", repID, self.title);
        return @"No Vote Found";
    }
}

- (BOOL)repVotedFor:(NSString *)repID {
    return [self repVoted: self.votesFor forRep:repID];
}

- (BOOL)repVotedAgainst:(NSString *)repID {
    return [self repVoted: self.votesAgainst forRep:repID];
}

- (BOOL)repDidNotVote:(NSString *)repID {
    return [self repVoted: self.votesAbstain forRep:repID];
}

- (BOOL)repVoted: (NSMutableArray *)arrayOfVotes forRep:(NSString *)repID {
    for (User *currentRep in arrayOfVotes) {
        [currentRep fetchIfNeeded];
        if ([currentRep.representativeID isEqualToString:repID]) {
            return YES;
        }
    }
    return NO;
}

@end

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
    self.votesFor = [dictionary[@"total"][@"yes"] integerValue];
    self.votesAgainst = [dictionary[@"total"][@"no"] integerValue];
    self.votesAbstain = [dictionary[@"total"][@"not_voting"] integerValue];
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

//- (void)setSponsor:(NSString *)sponsorID {
//    PFQuery *userQuery = [User query];
//    [userQuery whereKey:@"representativeID" equalTo:sponsorID];
//    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"Error with finding representative user with sponsorId: %@", error.localizedDescription);
//        } else {
//            if (users.count == 0) {
//                NSLog(@"Did not find representative associated with that sponsorId");
//            } else if (users.count == 1){
//                NSLog(@"Found representative user with sponsorId!");
//                self.sponsor = users[0];
//            } else {
//                NSLog(@"Found more than one user with sponsorId! %@", users);
//            }
//        }
//    }];
//}

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
//        NSLog(@"%lu bill with the same ID successfully found", bills.count);
//        NSLog(@"value is %@",bills[0][@"headBill"]);
        for (Bill *oldBill in bills) {
            if ([self.date isEqualToDate:oldBill.date]) {
//                NSLog(@"duplicate is found for bill %@ and time %@", self.billID, self.date);
                [self setValue:@(NO) forKey:@"headBill"];
                return YES;
            } else if (oldBill[@"headBill"] && ([self.date minutesFrom:oldBill.date] > 0)) {
//                NSLog(@"new head is saved for bill %@ and time %@", self.billID, self.date);
                [oldBill setValue:@(NO) forKey:@"headBill"];
                [oldBill save];
                [self setValue:@(YES) forKey:@"headBill"];
                return NO;
            }
        }
//        NSLog(@"new bill, but not the head, is saved for bill %@ and time %@", self.billID, self.date);
        [self setValue:@(NO) forKey:@"headBill"];
        return NO;
    } else {
        [self setValue:@(YES) forKey:@"headBill"];
        return NO;
    }
    
}

@end

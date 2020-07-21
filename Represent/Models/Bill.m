//
//  Bill.m
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "Bill.h"

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
@dynamic committee;
@dynamic forDescription;
@dynamic againstDescription;


#pragma mark - Init
+ (nonnull NSString *)parseClassName {
    return @"Bill";
}

#pragma mark - Setup


+ (Bill *) createBill: (NSDictionary *)dictionary {
    Bill *bill = [Bill new];
    if (dictionary[@"bill"][@"bill_id"]) {
        NSDictionary *billDictionary = dictionary[@"bill"];
        if ([Bill billExists:billDictionary[@"bill_id"]]) {
            return nil;
        }
        bill.billID = billDictionary[@"bill_id"];
        bill.number = billDictionary[@"number"];
//        bill.sponsor = billDictionary[@"sponsor_id"];
        bill.shortSummary = billDictionary[@"title"];
        bill.question = dictionary[@"question"];
    } else if (dictionary[@"nomination"][@"nomination_id"]) {
        NSDictionary *nominationDictionary = dictionary[@"nomination"];
        if ([Bill billExists:nominationDictionary[@"nomination_id"]]) {
            return nil;
        }
        bill.billID = nominationDictionary[@"nomination_id"];
        bill.number = nominationDictionary[@"number"];
    } else {
        NSLog(@"THIS BILL IS NOT A NOMINATION OR BILL");
    }
    
    [bill updateValues:dictionary];

    [bill save];
    
    return bill;
}

- (void)updateValues:(NSDictionary *)dictionary {
    self.type = dictionary[@"chamber"];
    self.title = dictionary[@"description"];
    self.result = dictionary[@"result"];
    self.date = [self formatDate:dictionary[@"date"]];
    self.votesFor = [dictionary[@"total"][@"yes"] integerValue];
    self.votesAgainst = [dictionary[@"total"][@"no"] integerValue];
    self.votesAbstain = [dictionary[@"total"][@"not_voting"] integerValue];
}

- (void)setSponsor:(NSString *)sponsorID {
    PFQuery *userQuery = [User query];
    [userQuery whereKey:@"objectId" equalTo:sponsorID];
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

- (NSDate *)formatDate:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

+ (BOOL)billExists: (NSString *)billID {
    PFQuery *billQuery = [Bill query];
    [billQuery whereKey:@"billID" equalTo:billID];
    NSArray *bills = [billQuery findObjects];
    if (bills.count > 0) {
        NSLog(@"One bill with the same ID successfully found");
        return YES;
    } else {
        NSLog(@"No bills found for billID %@", billID);
        return NO;
    }
}
@end

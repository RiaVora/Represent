//
//  Bill.m
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "Bill.h"

@implementation Bill

@dynamic createdAt;
@dynamic billID;
@dynamic title;
@dynamic forDescription;
@dynamic againstDescription;
@dynamic passed;
@dynamic position;
@dynamic votes;
@dynamic votesFor;
@dynamic votesAgainst;

#pragma mark - Init
+ (nonnull NSString *)parseClassName {
    return @"Bill";
}

#pragma mark - Setup


+ (void) createBill: (NSDictionary *)bill {
//    Bill *bill = [Bill new];
    
//    user.position = representative[@"title"];
//    user.shortPosition = representative[@"short_title"];
//    user.party = representative[@"party"];
//    user.contact = representative[@"contact_form"];
//    user.lastName = representative[@"last_name"];
//    [user signUpUser:representative[@"first_name"] email:@"" state:representative[@"state"] username:representative[@"id"] password:representative[@"date_of_birth"] isRepresentative:YES withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"Error adding representative: %@", error.localizedDescription);
//        } else {
//            NSLog(@"Successfully added Representative %@", user.username);
//        }
//    }];
}

@end

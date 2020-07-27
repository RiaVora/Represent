//
//  Bill.h
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "DateTools.h"

/*The Bill class is a PFObject class that is used to represent one Bill object from the Parse database. The Bill object contains attributes such as title, forDescription, passed, etc. and is displayed in a BillCell. The data for each bill is populated through the APIManager from the ProPublica API.*/


NS_ASSUME_NONNULL_BEGIN

@interface Bill : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *billID;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) User *sponsor;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *shortSummary;
@property (nonatomic, strong) NSString *longSummary;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *result;
@property (nonatomic) NSMutableArray *votesFor;
@property (nonatomic) NSMutableArray *votesAgainst;
@property (nonatomic) NSMutableArray *votesAbstain;
@property (nonatomic, assign) BOOL *headBill;
@property (nonatomic, strong) NSString *committee;
@property (nonatomic, strong) NSString *forDescription;
@property (nonatomic, strong) NSString *againstDescription;

+ (void) updateBills: (NSDictionary *)dictionary withCompletion:(void(^)(BOOL complete))completion;
+ (void) updateBills2: (NSDictionary *)dictionary;
+ (NSDate *)formatDate:(NSString *)dateString :(NSString *)timeString;
- (NSString *)voteOfRepresentative: (NSString *)repID;

@end

NS_ASSUME_NONNULL_END

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

/*PROPERTIES*/

/*The unique bill ID assigned by Congress, used to distinguish updates, duplicates, and new bills.*/
@property (nonatomic, strong) NSString *billID;

/*The chamber that the bill is in ("Senate" or "House").*/
@property (nonatomic, strong) NSString *type;

/*The sponsor for the bill, linked to a specific representative during creation of the bill.*/
@property (nonatomic, strong) User *sponsor;

/*The title of the bill.*/
@property (nonatomic, strong) NSString *title;

/*The short summary of the bill.*/
@property (nonatomic, strong) NSString *shortSummary;

/*The date of action for this bill on the floor.*/
@property (nonatomic, strong) NSDate *date;

/*The result of the bill (i.e. "Passed", "Failed").*/
@property (nonatomic, strong) NSString *result;

/*An array of dictionaries, each dictionary representing a "Yes" vote and a representative ID.*/
@property (nonatomic) NSMutableArray *votesFor;

/*An array of dictionaries, each dictionary representing a "No" vote and a representative ID.*/
@property (nonatomic) NSMutableArray *votesAgainst;

/*An array of dictionaries, each dictionary representing a "Not Voting" and a representative ID.*/
@property (nonatomic) NSMutableArray *votesAbstain;

/*Signifies whether this bill is the most recent update (out of all bills with the same bill ID).*/
@property (nonatomic, assign) BOOL *headBill;

/*The committees involved in creating and supporting the bill.*/
@property (nonatomic, strong) NSString *committee;

/*A short description of the argument for voting "Yes" to the bill.*/
@property (nonatomic, strong) NSString *forDescription;

/*A short description of the argument for voting "No" to the bill.*/
@property (nonatomic, strong) NSString *againstDescription;


/*METHODS*/

/*Creates a new bill or discards a duplicate based on the dictionary passed in, used by BillsViewController.*/
+ (void) updateBills: (NSDictionary *)dictionary withCompletion:(void(^)(BOOL isDuplicate, Bill *bill))completion;

/*Creates a new search bill or discards a duplicate based on the dictionary passed in, used by BillsViewController.*/
+ (void) updateBillsFromSearch: (NSDictionary *)dictionary withCompletion:(void(^)(Bill *bill))completion;

/*Returns the vote of a representative based off of the bill's vote arrays and the given representative ID.*/
- (NSString *)voteOfRepresentative: (NSString *)repID;

@end

NS_ASSUME_NONNULL_END

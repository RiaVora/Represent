//
//  APIManager.h
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <Foundation/Foundation.h>

/*The APIManager class is used to faciliate network requests between the ProPublica Congress API and my app. The APIManager fetches information about representatives and bills based on the URLs I pass in and the API key I have.*/

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

/*METHODS*/

/*Fetches 20 recent bills from the API, offset by the given parameter.*/
- (void)fetchRecentBills:(int)offset :(void(^)(NSArray *bills, NSError *error))completion;

/*Fetches 20 most relevant bills given the parameter query.*/
- (void)fetchSearchedBills: (NSString *)query :(void(^)(NSArray *bills, NSError *error))completion;

/*Fetches all active senators, only used once for setup purposes.*/
- (void)fetchSenators:(void(^)(NSArray *senators, NSError *error))completion;

/*Fetches all active members of the house of representatives, only used once for setup purposes.*/
- (void)fetchHouseReps:(void(^)(NSArray *reps, NSError *error))completion;

/*Fetches the votes of each representative, and is associated with a recent bill.*/
- (void)fetchVotes: (NSString *)votesURL :(void(^)(NSArray *votes, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END

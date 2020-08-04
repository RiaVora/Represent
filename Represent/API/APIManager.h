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

/*Fetches 20 recent bills from the API, offset by the given parameter.
 
 @param offset is the amount to offset the call to the API for recent bills by
 @completion gives an array containing a dictionary for each recent bils if successful; error otherwise
 */
- (void)fetchRecentBills:(int)offset :(void(^)(NSArray *bills, NSError *error))completion;

/*Fetches all active senators, only used once for setup purposes.
 
 @completion gives an array containing a dictionary for each senator if successful; error otherwise
 */
- (void)fetchSenators:(void(^)(NSArray *senators, NSError *error))completion;

/*Fetches all active members of the house of representatives, only used once for setup purposes.
 
 @completion gives an array containing a dictionary for each representative if successful; error otherwise
 */
- (void)fetchHouseReps:(void(^)(NSArray *reps, NSError *error))completion;

/*Fetches the votes of each representative, and is associated with a recent bill.
 
 @param votesURL is the url from the bill that is used to call the API for a detailed breakdown of votes on the bill
 @completion gives an array containing a dictionary for votes of each representative/senator voting on the bill; error otherwise
 */
- (void)fetchVotes: (NSString *)votesURL :(void(^)(NSArray *votes, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END

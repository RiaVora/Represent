//
//  APIManager.h
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <Foundation/Foundation.h>

/*The APIManager class is used to faciliate network requests between the ProPublica Congress API and my app. The APIManager fetches information about representatives and bills based on the URLs I pass in and the API key I have. */

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

@property (nonatomic, strong) NSURLSession *session;
- (void)fetchRecentBills:(int)offset :(void(^)(NSArray *bills, NSError *error))completion;
- (void)fetchSenators:(void(^)(NSArray *senators, NSError *error))completion;
- (void)fetchHouseReps:(void(^)(NSArray *reps, NSError *error))completion;
- (void)fetchVotes: (NSString *)votesURL :(void(^)(NSArray *votes, NSError *error))completion;
- (void)fetchSearchedBills: (NSString *)query :(void(^)(NSArray *bills, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END

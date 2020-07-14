//
//  APIManager.h
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

@property (nonatomic, strong) NSURLSession *session;
- (void)fetchRecentBills:(void(^)(NSArray *bills, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END

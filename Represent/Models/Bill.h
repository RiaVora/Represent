//
//  Bill.h
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Bill : PFObject<PFSubclassing>

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *billID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *passed;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSDictionary *votes;
@property (nonatomic, strong) NSNumber *votesFor;
@property (nonatomic, strong) NSNumber *votesAgainst;

@end

NS_ASSUME_NONNULL_END

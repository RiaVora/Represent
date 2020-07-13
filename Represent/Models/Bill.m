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


+ (nonnull NSString *)parseClassName {
    return @"Bill";
}

@end

//
//  Question.h
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Question : PFObject

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *questionID;
@property (nonatomic, strong) User *author;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSNumber *voteCount;
@property (nonatomic, strong) User *representative;

+ (void) postUserQuestion: ( NSString * _Nullable )question forRepresentative: ( User * _Nullable )representative withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END

//
//  Question.h
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

/*The Question class is a PFObject class that is used to represent one Question object from the Parse database. The Question object contains attributes such as text, author, voteCount, etc. and is displayed in a QuestionCell.*/


NS_ASSUME_NONNULL_BEGIN
@class User;
@interface Question : PFObject<PFSubclassing>

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *questionID;
@property (nonatomic, strong) User *author;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSNumber *voteCount;
@property (nonatomic, strong) User *representative;

+ (void) postUserQuestion: ( NSString * _Nullable )question forRepresentative: ( User * _Nullable )representative withCompletion: (PFBooleanResultBlock  _Nullable)completion;
- (void)vote:(BOOL)vote;
@end

NS_ASSUME_NONNULL_END

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

/*The user who wrote the question.*/
@property (nonatomic, strong) User *author;

/*The content of the question (the question as written by the author).*/
@property (nonatomic, strong) NSString *text;

/*The number of votes for the question.*/
@property (nonatomic, strong) NSNumber *voteCount;

/*The representative that the question is written for.*/
@property (nonatomic, strong) User *representative;

/*Is used externally to create a Question with the given arguments.*/
+ (void) postUserQuestion: ( NSString * _Nullable )question forRepresentative: ( User * _Nullable )representative withCompletion: (PFBooleanResultBlock  _Nullable)completion;

/*Is used to increase the voteCount of a Question.*/
- (void)vote:(BOOL)vote;

@end

NS_ASSUME_NONNULL_END

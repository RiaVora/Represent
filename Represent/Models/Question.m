//
//  Question.m
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "Question.h"

@implementation Question

@dynamic author;
@dynamic text;
@dynamic voteCount;
@dynamic representative;

#pragma mark - Init

+ (nonnull NSString *)parseClassName {
    return @"Question";
}

#pragma mark - Setup

+ (void) postUserQuestion: ( NSString * _Nullable )question forRepresentative: ( User * _Nullable )representative withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Question *newQuestion = [Question new];
    newQuestion.text = question;
    newQuestion.author = [User currentUser];
    newQuestion.voteCount = @(0);
    newQuestion.representative = representative;
    [newQuestion saveInBackgroundWithBlock: completion];
}

#pragma mark - Actions

- (void)vote:(BOOL)vote {
    if (vote) {
        self.voteCount = [NSNumber numberWithInt:([self.voteCount intValue] + 1)];
    } else {
        self.voteCount = [NSNumber numberWithInt:([self.voteCount intValue] - 1)];
    }
}

@end

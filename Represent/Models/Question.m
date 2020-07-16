//
//  Question.m
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "Question.h"

@implementation Question

@dynamic createdAt;
@dynamic questionID;
@dynamic author;
@dynamic text;
@dynamic voteCount;
@dynamic representative;

+ (nonnull NSString *)parseClassName {
    return @"Question";
}

+ (void) postUserQuestion: ( NSString * _Nullable )question forRepresentative: ( User * _Nullable )representative withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Question *newQuestion = [Question new];
    newQuestion.text = question;
    newQuestion.author = [User currentUser];
    newQuestion.voteCount = @(0);
    newQuestion.representative = representative;
    
    [newQuestion saveInBackgroundWithBlock: completion];
}

- (void)addVote {
    self.voteCount = [NSNumber numberWithInt:([self.voteCount intValue] + 1)];
}




@end

//
//  QuestionCell.m
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "QuestionCell.h"


@interface QuestionCell ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (weak, nonatomic) IBOutlet UIImageView *votedView;
@property (weak, nonatomic) IBOutlet UIImageView *topQuestionView;
@property (weak, nonatomic) IBOutlet UIImageView *numberQuestionView;

@end

@implementation QuestionCell

#pragma mark - Init

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//}

#pragma mark - Setup

- (void)updateValues: (NSInteger)row {
    self.questionLabel.text = self.question.text;
    [self.usernameButton setTitle:self.question.author.username forState:UIControlStateNormal];
    [self setProfilePhoto];
    [self setNumber:row];
    if (row < [Utils getLimit]) {
        NSLog(@"row is %ld", row);
        [self setTopQuestion];
    } else {
        [self setNormalQuestion];
    }
    self.timestampLabel.text = self.question.createdAt.shortTimeAgoSinceNow;
    User *user = [User currentUser];
    if (user.isRepresentative) {
        [self.voteButton setTitle:@"Answer" forState:UIControlStateNormal];
        self.voteCountLabel.text = [NSString stringWithFormat:@"%@", self.question.voteCount];
    } else {
        [self updateVoteButton:[user hasVoted:self.question]];
    }
}

- (void)setTopQuestion{
//    [self setBackgroundColor:UIColor.systemGray3Color];
    [self.topQuestionView setHidden:false];
    [self.numberQuestionView setTintColor:UIColor.systemGreenColor];
//    [self.topQuestionView setBackgroundColor:UIColor.whiteColor];
//    self.topQuestionView.layer.cornerRadius = self.topQuestionView.frame.size.width / 2;
}

- (void)setNormalQuestion {
    [self setBackgroundColor:UIColor.whiteColor];
    [self.topQuestionView setHidden:true];
}

- (void)setNumber: (NSInteger)row {
    if (row <= 50) {
        [self.numberQuestionView setHidden:false];
        [self.numberQuestionView setImage:[UIImage systemImageNamed:[NSString stringWithFormat:@"%ld.square.fill", (long)row + 1]]];
    } else {
        [self.numberQuestionView setHidden:true];
    }

}

- (void)setProfilePhoto {
    if (self.question.author.profilePhoto) {
        [self.question.author.profilePhoto getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error with getting data from Image: %@", error.localizedDescription);
            } else {
                self.profileView.image = [Utils resizeImage:[UIImage imageWithData:data] withSize:(CGSizeMake(35, 35))];
                self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2;
            }
        }];
    } else {
        NSLog(@"Error, no profile photo set");
    }
}

- (void)updateVoteButton:(BOOL)addingVote {
    if (addingVote) {
        [self.voteButton setTitleColor:UIColor.darkGrayColor forState:UIControlStateNormal];
        [self.voteButton setTitle:@"Voted" forState:UIControlStateNormal];
        [self.votedView setHighlighted:NO];
        
    } else {
        [self.voteButton setTitleColor:UIColor.systemYellowColor forState:UIControlStateNormal];
        [self.voteButton setTitle:@"Vote" forState:UIControlStateNormal];
        [self.votedView setHighlighted:YES];
        
    }
    self.voteCountLabel.text = [NSString stringWithFormat:@"%@", self.question.voteCount];
}

#pragma mark - Actions

- (IBAction)pressedVote:(id)sender {
    User *user = [User currentUser];
    BOOL hasRemainingVotes = [user votesLeft] && ![user hasVoted:self.question];
    BOOL canRemoveVote = [user hasVoted:self.question] && [user.availableVoteCount intValue] < 5;
    if (hasRemainingVotes || canRemoveVote) {
        [self executeVote:YES];
    } else {
        if ([user hasVoted:self.question] && [user.availableVoteCount intValue] >= 5) {
            [self removeExtraVoteAlert];
        } else {
            [Utils displayAlertWithOk:@"Run out of Votes" message:@"You can only vote 5x a day! Please come back tomorrow for 5 more votes." viewController:self.controllerDelegate];
        }
    }
}

- (void)executeVote: (BOOL)normal{
    User *user = [User currentUser];
    BOOL addingVote = NO;
    if (normal) {
        addingVote = [user voteOnQuestion:self.question];
    } else {
        [user removeObject:self.question forKey:@"votedQuestions"];
        [user saveInBackground];
    }
    [self.question vote:addingVote];
    [self updateVoteButton:addingVote];
    
    [self.question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"Error with voting on question: %@", error.localizedDescription);
            [Utils displayAlertWithOk:@"Error voting on Question" message:error.localizedDescription viewController:self.inputViewController];
        } else {
            NSLog(@"Succesfully voted %d on question '%@'", addingVote, self.question.text);
            [self.delegate didVote:self.question];
        }
    }];
}

- (void)removeExtraVoteAlert {
    UIAlertController *alert = [Utils makeAlert:@"Cannot add more votes" :@"You can only have up to 5 votes at a time! This removed vote will not give you a vote back."];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
        [self executeVote:NO];
    }];
    [alert addAction:continueAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancelAction];
    
    [self.controllerDelegate presentViewController:alert animated:YES completion:^{}];
}

@end

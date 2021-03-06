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
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

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
        [self setTopQuestion];
    } else {
        [self setNormalQuestion];
    }
    self.timestampLabel.text = [NSString stringWithFormat: @"%@ ago", self.question.createdAt.shortTimeAgoSinceNow];
    self.voteCountLabel.text = [NSString stringWithFormat:@"%@", self.question.voteCount];
    User *user = [User currentUser];
    if (user.isRepresentative) {
        [self updateAnswer];
    } else {
        [self updateVoteButton:[user hasVoted:self.question]];
    }
}

- (void)setTopQuestion{
    [self.topQuestionView setHidden:false];
}

- (void)setNormalQuestion {
    [self setBackgroundColor:UIColor.whiteColor];
    [self.topQuestionView setHidden:true];
}

- (void)setNumber: (NSInteger)row {
    [self.numberLabel setText:[NSString stringWithFormat:@"%ld", (long)row + 1]];
    [self.numberLabel setTextColor:UIColor.systemGray2Color];
    if (row <= 98) {
        [self.numberLabel setFont:[UIFont systemFontOfSize:20]];
    } else {
        [self.numberLabel setFont:[UIFont systemFontOfSize:16]];

    }

}

- (void)setProfilePhoto {
    if (self.question.author.profilePhoto) {
        [self.question.author.profilePhoto getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error with getting data from Image: %@", error.localizedDescription);
            } else {
                self.profileView.image = [Utils resizeImage:[UIImage imageWithData:data] withSize:(CGSizeMake(40, 40))];
                [self.profileView setBackgroundColor:nil];
            }
        }];
    }
    self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2;
}

- (void)updateVoteButton:(BOOL)addingVote {
    self.voteButton.layer.cornerRadius = 10;
    if (self.question.answer) {
        [self showAnswered];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self.votedView setHidden:YES];
        if (addingVote) {
            [self.voteButton setTitleColor:UIColor.darkGrayColor forState:UIControlStateNormal];
            [self.voteButton setTitle:@"Voted" forState:UIControlStateNormal];
            [self.voteButton setBackgroundColor:UIColor.systemGray4Color];
            [self.voteButton.layer setBorderWidth:0.5];
            [self.voteButton.layer setBorderColor:UIColor.darkGrayColor.CGColor];
//            [self.voteButton.layer setBorderWidth:1];
//            [self.votedView setImage:[UIImage systemImageNamed:@"checkmark.square.fill"]];
//            [self.votedView setTintColor:UIColor.systemGrayColor];
            
        } else {
            [self.voteButton setTitleColor:[Utils getDarkYellow] forState:UIControlStateNormal];
            [self.voteButton setTitle:@"Vote" forState:UIControlStateNormal];
            [self.voteButton setBackgroundColor:[Utils getYellow]];
            [self.voteButton.layer setBorderWidth:0.5];
            [self.voteButton.layer setBorderColor:[Utils getDarkYellow].CGColor];
//            [self.votedView setImage:[UIImage systemImageNamed:@"square"]];
//            [self.votedView setTintColor:UIColor.systemYellowColor];
        }
    }
}

- (void)updateAnswer {
    if (self.question.answer) {
        [self showAnswered];
        [self setAccessoryType:UITableViewCellAccessoryNone];
    } else {
        self.userInteractionEnabled = YES;
        [self.voteButton setHidden:YES];
        [self.votedView setHidden:YES];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
}

- (void)showAnswered {
    self.userInteractionEnabled = YES;
    [self.voteButton setHidden:NO];
    [self.voteButton setTitle:@"Answered" forState:UIControlStateNormal];
    [self.voteButton setTitleColor:UIColor.systemGreenColor forState:UIControlStateNormal];
    [self.votedView setHidden:NO];
    [self.votedView setImage:[UIImage systemImageNamed:@"checkmark.seal.fill"]];
    [self.votedView setTintColor:UIColor.systemGreenColor];
    [self.voteButton setBackgroundColor:nil];
    [self.voteButton.layer setBorderWidth:0];

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
    self.voteCountLabel.text = [NSString stringWithFormat:@"%@", self.question.voteCount];
    
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

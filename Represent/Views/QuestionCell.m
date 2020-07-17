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
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;


@end

@implementation QuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateValues: (NSInteger)row {
    self.questionLabel.text = self.question.text;
    self.usernameLabel.text = self.question.author.username;
    [self setProfilePhoto];
    NSInteger limit = 3;
    if (row < limit) {
        [self setBackgroundColor:UIColor.lightGrayColor];
    } else {
        [self setBackgroundColor:UIColor.whiteColor];

    }
    User *user = [User currentUser];
    [self updateVoteButton:[user hasVoted:self.question]];
    self.timestampLabel.text = self.question.createdAt.shortTimeAgoSinceNow;
}

- (void)setProfilePhoto {
    if (self.question.author.profilePhoto) {
        [self.question.author.profilePhoto getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error with getting data from Image: %@", error.localizedDescription);
            } else {
                self.profileView.image = [Utils resizeImage:[UIImage imageWithData:data] withSize:(CGSizeMake(35, 35))];
            }
        }];
    } else {
        NSLog(@"Error, no profile photo set");
    }
}

- (IBAction)pressedVote:(id)sender {
    User *user = [User currentUser];
    BOOL addingVote = [user voteOnQuestion:self.question];
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

- (void)updateVoteButton:(BOOL)addingVote {
    if (addingVote) {
        [self.voteButton setTitleColor:UIColor.darkGrayColor forState:UIControlStateNormal];
        [self.voteButton setTitle:@"Voted" forState:UIControlStateNormal];
    } else {
        [self.voteButton setTitleColor:UIColor.systemYellowColor forState:UIControlStateNormal];
        [self.voteButton setTitle:@"Vote" forState:UIControlStateNormal];
    }
    self.voteCountLabel.text = [NSString stringWithFormat:@"%@", self.question.voteCount];
}

@end

//
//  VoteCell.m
//  Represent
//
//  Created by Ria Vora on 7/24/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "VoteCell.h"

@interface VoteCell ()

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *voteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sponsorImageView;

@end

@implementation VoteCell

#pragma mark - Setup

- (void)updateValues {
    self.firstNameLabel.text = [NSString stringWithFormat: @"%@ %@", self.representative.shortPosition, self.representative.firstName];
    self.lastNameLabel.text = self.representative.lastName;
    self.stateLabel.text = self.representative.state.uppercaseString;
    [Utils setPartyLabel:self.representative.party :self.partyLabel];
    [self setVote];
    [self setSponsor];
}

- (void)setVote {
    NSString *vote = [self.bill voteOfRepresentative:self.representative.representativeID];
    if ([vote isEqualToString:@"Yes"]) {
        [self.voteImageView setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
        [self.voteImageView setTintColor:UIColor.systemGreenColor];
    } else if ([vote isEqualToString:@"No"]) {
        [self.voteImageView setImage:[UIImage systemImageNamed:@"xmark.circle.fill"]];
        [self.voteImageView setTintColor:UIColor.systemRedColor];
    } else {
        [self.voteImageView setImage:[UIImage systemImageNamed:@"minus.circle.fill"]];
        [self.voteImageView setTintColor:UIColor.systemGrayColor];
    }
    
//    if ([self.representative.firstName isEqualToString:@"Pete"]) {
//        NSLog(@"Pete voted %@ on bill %@", vote, self.bill.title);
//    } else if ([self.representative.firstName isEqualToString:@"Kamala"]) {
//        NSLog(@"Kamala voted %@ on bill %@", vote, self.bill.title);
//    }
}

- (void)setSponsor {
    if ([self.representative.representativeID isEqualToString:self.bill.sponsor.representativeID]) {
        [self.sponsorImageView setHidden:NO];
    } else {
        [self.sponsorImageView setHidden:YES];
    }
}

@end

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

- (void)updateValues {
    self.firstNameLabel.text = [NSString stringWithFormat: @"%@ %@", self.representative.shortPosition, self.representative.firstName];
    self.lastNameLabel.text = self.representative.lastName;
    
    [Utils setPartyLabel:self.representative.party :self.partyLabel];
    self.stateLabel.text = self.representative.state.uppercaseString;
    NSString *vote = [self.bill voteOfRepresentative:self.representative.representativeID];
    if ([vote isEqualToString:@"Yes"]) {
        [self.voteImageView setHighlighted:NO];
        [self.voteImageView setTintColor:UIColor.systemGreenColor];
    } else if ([vote isEqualToString:@"No"]) {
        [self.voteImageView setHighlighted:YES];
        [self.voteImageView setTintColor:UIColor.systemRedColor];
    } else {
        [self.voteImageView setImage:nil];
    }
    
    if ([self.representative.representativeID isEqualToString:self.bill.sponsor.representativeID]) {
        [self.sponsorImageView setHidden:NO];
    } else {
        [self.sponsorImageView setHidden:YES];
    }
}

@end

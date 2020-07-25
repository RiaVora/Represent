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
@property (weak, nonatomic) IBOutlet UIImageView *voteImageView;

@end

@implementation VoteCell

- (void)updateValues {
    self.firstNameLabel.text = [NSString stringWithFormat: @"%@ %@", self.representative.shortPosition, self.representative.firstName];
    self.lastNameLabel.text = self.representative.lastName;
    [Utils setPartyLabel:self.representative.party :self.partyLabel];
    NSString *vote = self.vote[@"vote_position"];
    if ([vote isEqualToString:@"Yes"]) {
        [self.voteImageView setHighlighted:NO];
        [self.voteImageView setTintColor:UIColor.systemGreenColor];
    } else if ([vote isEqualToString:@"No"]) {
        [self.voteImageView setHighlighted:YES];
        [self.voteImageView setTintColor:UIColor.systemRedColor];

    } else {
        NSLog(@"The vote is not a yes or no, it is %@", vote);
    }
    
}

@end

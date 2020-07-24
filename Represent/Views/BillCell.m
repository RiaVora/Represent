//
//  BillCell.m
//  Represent
//
//  Created by Ria Vora on 7/17/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "BillCell.h"



@interface BillCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesForLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesAgainstLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesAbstainLabel;


@end

@implementation BillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateValues {
    self.titleLabel.text = self.bill.title;
    if (self.bill.shortSummary) {
        self.shortSummaryLabel.text = self.bill.shortSummary;
    } else {
        self.shortSummaryLabel.text = @"";
    }
    [Utils setResultLabel:self.bill.result forLabel:self.resultLabel];
    

    self.timestampLabel.text = [NSString stringWithFormat:@"%@", self.bill.date.timeAgoSinceNow];
    if ([self.bill.type isEqualToString:@"House"]) {
        self.typeLabel.text = @"House of Representatives";
    } else {
        self.typeLabel.text = self.bill.type;
    }
    
    self.votesForLabel.text = [NSString stringWithFormat:@"%ld", (long)self.bill.votesFor];
    self.votesAgainstLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesAgainst];
    self.votesAbstainLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesAbstain];
//
//    BOOL cont = [self.bill.type isEqualToString:@"Senate"];
//    if (self.vote1Label && cont) {
//        [self updateVotes];
//    } if (!cont && self.vote1Label) {
//        self.vote1Label.text = @"";
//        self.vote2Label.text = @"";
//    }

}

- (void)updateVotes {
    APIManager *manager = [APIManager new];
    [manager fetchVotes:self.bill.votesURL :^(NSArray * _Nonnull votes, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error with fetching votes from API");
        } else {
            NSLog(@"Success with fetching votes from API!");
            User *currentUser = [User currentUser];
            User *rep1 = currentUser.followedRepresentatives[0];
            User *rep2 = currentUser.followedRepresentatives[1];
            NSString *ID1 = rep1.representativeID;
            NSString *ID2 = rep2.representativeID;
            NSArray *filteredData1 = [votes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(member_id ==[c]%@)", ID1]];
            NSArray *filteredData2 = [votes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(member_id ==[c]%@)", ID2]];

                
                
                
//                for (NSDictionary *repVote in filteredData) {
//                    NSLog(@"found the rep %@ with vote %@", repVote[@"name"], repVote[@"vote_position"]);
//                }

        }
    }];
    
}



@end

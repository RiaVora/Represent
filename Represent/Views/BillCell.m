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
@property (weak, nonatomic) IBOutlet UILabel *votesForLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesAgainstLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesAbstainLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

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
    
    self.resultLabel.text = self.bill.result;
    self.resultLabel.textColor = UIColor.systemGreenColor;
    self.timestampLabel.text = [NSString stringWithFormat:@"%@", self.bill.date.timeAgoSinceNow];
    self.votesForLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesFor];
    self.votesAgainstLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesAgainst];
    self.votesAbstainLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesAbstain];
    
}



@end

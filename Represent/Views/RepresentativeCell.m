//
//  RepresentativeCell.m
//  Represent
//
//  Created by Ria Vora on 7/16/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "RepresentativeCell.h"

@interface RepresentativeCell ()

@property (weak, nonatomic) IBOutlet UILabel *representativeLabel;

@end

@implementation RepresentativeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateValues {
    self.representativeLabel.text = [self.representative fullTitleRepresentative];
}

@end

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

- (void)updateValues {
    self.questionLabel.text = self.question.text;
    self.usernameLabel.text = self.question.author.username;
    
}

@end

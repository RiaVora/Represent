//
//  AnswerViewController.m
//  Represent
//
//  Created by Ria Vora on 8/5/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "AnswerViewController.h"

@interface AnswerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topQuestionView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateValues];
}

- (void)updateValues {
    self.questionLabel.text = self.question.text;
    [self.usernameButton setTitle:self.question.author.username forState:UIControlStateNormal];
    [self setProfilePhoto];
    self.timestampLabel.text = self.question.createdAt.shortTimeAgoSinceNow;
    self.voteCountLabel.text = [NSString stringWithFormat:@"%@", self.question.voteCount];
    User *user = [User currentUser];
}

- (void)setTopQuestion{
    [self.topQuestionView setHidden:false];
}

- (void)setNormalQuestion {
    [self.topQuestionView setHidden:true];
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

@end

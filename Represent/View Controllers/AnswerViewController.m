//
//  AnswerViewController.m
//  Represent
//
//  Created by Ria Vora on 8/5/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "AnswerViewController.h"

@interface AnswerViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@property (weak, nonatomic) IBOutlet UIButton *answerButton;
@property (weak, nonatomic) IBOutlet UILabel *answerTitleLabel;
@property (weak, nonatomic) User *user;

@end

@implementation AnswerViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.answerTextView.delegate = self;
//    self.answerTextView.backgroundColor = UIColor.flatLimeColor;
//    self.answerTextView.layer.cornerRadius = 10;
    [self updateValues];
}

#pragma mark - Setup

- (void)updateValues {
    [self setDetails];
    if ([self.user.username isEqualToString:self.question.representative.username]) {
        [self setRepView];
    } else {
        [self setUserView];
    }

}
- (void)setDetails {
    self.questionLabel.text = self.question.text;
    [self.usernameButton setTitle:self.question.author.username forState:UIControlStateNormal];

    [self setProfilePhoto];
    self.timestampLabel.text = [NSString stringWithFormat: @"%@", self.question.createdAt.timeAgoSinceNow];
    self.voteCountLabel.text = [NSString stringWithFormat:@"%@", self.question.voteCount];
    self.user = [User currentUser];
}

- (void)setRepView {
    [self.answerTitleLabel setText:@"Answer Below:"];
    self.answerTextView.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
    if (self.question.answer) {
        [self.answerButton setAlpha:0];
        [self.answerButton setTitle:@"Update Answer" forState:UIControlStateNormal];
        [self.answerTextView setText:self.question.answer];
    } else {
        [self setPlaceholderText];
    }
}

- (void)setUserView {
    if (self.question.answer) {
        [self.answerButton setHidden:YES];
        [self.answerTextView setEditable:NO];
        [self.answerTextView setText:self.question.answer];
        [self.answerTitleLabel setText:[NSString stringWithFormat:@"%@ answered: ", [self.question.representative fullTitleRepresentative]]];
    } else {
        [Utils displayAlertWithOk:@"Error" message:@"Should not be able to see answer screen if there is no answer" viewController:self];
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

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.textColor isEqual: UIColor.lightGrayColor]) {
        textView.text = @"";
        textView.textColor = UIColor.blackColor;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.answerButton setAlpha:1];
    }];
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        [self setPlaceholderText];
    }
}

- (void)setPlaceholderText {
    self.answerTextView.text = @"What's your response?";
    self.answerTextView.textColor = UIColor.lightGrayColor;
    self.answerTextView.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
}

#pragma mark - Actions

- (IBAction)pressedAnswer:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BOOL answerExists = [Utils checkExists:self.answerTextView.text :@"Answer" :self];
    if (answerExists) {
        [self.question setValue:self.answerTextView.text forKey:@"answer"];
        [self.question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error with saving answer to question: %@", error.localizedDescription);
            } else {
                [UIView animateWithDuration:3 animations:^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
                [self.answerButton setTitle:@"Update Answer" forState:UIControlStateNormal];
                [self.answerButton setAlpha:0];
                [Utils displayAlertWithOk:@"Answer Saved" message:[NSString stringWithFormat: @"Thank you for answering %@'s question!", self.question.author.username] viewController:self];
            }
        }];
    }
}

- (IBAction)pressedUsername:(id)sender {
    [self performSegueWithIdentifier:@"profileSegue" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"profileSegue"]) {
        ProfileViewController *profileVC = [segue destinationViewController];
        profileVC.user = self.question.author;
    }
}



@end

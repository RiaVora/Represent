//
//  PostQuestionsViewController.m
//  Represent
//
//  Created by Ria Vora on 7/16/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "PostQuestionsViewController.h"

@interface PostQuestionsViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UIButton *representativeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableViewRepresentatives;
@property (strong, nonatomic) NSArray *representatives;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (nonatomic) NSInteger characterLimit;

@end

@implementation PostQuestionsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.questionTextView.delegate = self;
    self.characterLimit = 250;
    [self setupValues];
}

#pragma mark - Setup

- (void)setupTableView {
    self.tableViewRepresentatives.delegate = self;
    self.tableViewRepresentatives.dataSource = self;
    self.tableViewRepresentatives.hidden = YES;
    self.tableViewRepresentatives.tableFooterView = [UIView new];
}
- (void)setupValues {
    [self setPlaceholderText];
    self.representatives = [User currentUser].followedRepresentatives;
    [self.currentRepresentative fetch];
    [self.representativeButton setTitle:[self.currentRepresentative fullTitleRepresentative] forState:UIControlStateNormal];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.textColor isEqual: UIColor.lightGrayColor]) {
        textView.text = @"";
        textView.textColor = UIColor.blackColor;
    }
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        [self setPlaceholderText];
    }
}

- (void)setPlaceholderText {
    self.questionTextView.text = @"What do you want to ask?";
    self.questionTextView.textColor = UIColor.lightGrayColor;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    if (range.length + range.location > textView.text.length) {
        return NO;
    }
    NSInteger newLength = [textView.text length] + [string length] - range.length;
    self.characterCountLabel.text = [NSString stringWithFormat:@"%ld out of %ld", newLength, self.characterLimit];
    if (newLength > self.characterLimit) {
        [textView setTextColor:UIColor.systemRedColor];
        [self.characterCountLabel setTextColor:UIColor.systemRedColor];
    } else if ([textView.textColor isEqual:UIColor.systemRedColor]){
        [textView setTextColor:UIColor.blackColor];
        [self.characterCountLabel setTextColor:UIColor.blackColor];
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)pressedCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)pressedPost:(id)sender {
    NSString *questionText = self.questionTextView.text;
    BOOL questionExists = [Utils checkExists: questionText:@"Question" :self];
    BOOL metLimit = [Utils checkLengthLessOrEquals:questionText :self.characterLimit :@"Question" :self];
    if (questionExists && metLimit) {
        [self dismissViewControllerAnimated:true completion:nil];
        self.questionTextView.text = @"";
        [self.delegate didPost:questionText:self.currentRepresentative];
    }
}

- (IBAction)pressedRepresentative:(id)sender {
    self.tableViewRepresentatives.hidden = !(self.tableViewRepresentatives.hidden);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepresentativeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepresentativeCell"];
    User *representative = self.representatives[indexPath.row];
    [representative fetch];
    if (cell == nil) {
        cell = [[RepresentativeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RepresentativeCell"];
    }
    cell.representative = representative;
    [cell updateValues];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.representatives.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RepresentativeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.representativeButton setTitle:[cell.representative fullTitleRepresentative] forState:UIControlStateNormal];
    self.currentRepresentative = cell.representative;
    tableView.hidden = YES;
}

@end

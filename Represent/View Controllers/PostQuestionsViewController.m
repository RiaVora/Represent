//
//  PostQuestionsViewController.m
//  Represent
//
//  Created by Ria Vora on 7/16/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "PostQuestionsViewController.h"

@interface PostQuestionsViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *questionField;
@property (weak, nonatomic) IBOutlet UIButton *representativeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableViewRepresentatives;
@property (strong, nonatomic) NSArray *representatives;

@end

@implementation PostQuestionsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.questionField.delegate = self;
    [self setupValues];
}

#pragma mark - Setup

- (void)setupTableView {
    self.tableViewRepresentatives.delegate = self;
    self.tableViewRepresentatives.dataSource = self;
    self.tableViewRepresentatives.hidden = YES;
    self.tableViewRepresentatives.tableFooterView = [[UIView alloc]
                                                     initWithFrame:CGRectZero];
}

- (void)setupValues {
    self.questionField.text = @"What do you want to ask?";
    self.questionField.textColor = UIColor.lightGrayColor;
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
        textView.text = @"What do you want to ask?";
        textView.textColor = UIColor.lightGrayColor;
    }
}

#pragma mark - Actions

- (IBAction)pressedCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (NSString *)pressedPost {
    NSString *questionText = self.questionField.text;
    self.questionField.text = @"";
    BOOL questionExists = [Utils checkExists: questionText:@"Question" :self];
    if (questionExists) {
        return questionText;
    } else {
        return nil;
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

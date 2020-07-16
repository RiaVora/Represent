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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.questionField.delegate = self;
    [self setupValues];
}

- (void)setupTableView {
    self.tableViewRepresentatives.delegate = self;
    self.tableViewRepresentatives.dataSource = self;
    self.tableViewRepresentatives.hidden = YES;
}

- (void)setupValues {
    self.questionField.text = @"What do you want to ask?";
    self.questionField.textColor = UIColor.lightGrayColor;
    
    self.representatives = [User currentUser].followedRepresentatives;
    [self.currentRepresentative fetch];
    [self.representativeButton setTitle:[self.currentRepresentative fullTitleRepresentative] forState:UIControlStateNormal];
}

- (void)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.textColor isEqual: UIColor.lightGrayColor]) {
        textView.text = @"";
        textView.textColor = UIColor.blackColor;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"What do you want to ask?";
       textView.textColor = UIColor.lightGrayColor;
    }
}
     


- (IBAction)pressedCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)pressedAsk:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    BOOL questionExists = [Utils checkExists:self.questionField.text :@"Question" :self];
    if (questionExists) {
        [self postQuestion:sender];
    }
}

- (void)postQuestion: (id)sender {
    [Question postUserQuestion:self.questionField.text forRepresentative:self.currentRepresentative withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"Error posting question: %@", error.localizedDescription);
            [Utils displayAlertWithOk:@"Error with Posting Question" message:error.localizedDescription viewController:self];
        } else {
            NSLog(@"Successfully posted Question %@ for %@!", self.questionField.text, self.currentRepresentative.username);
            self.questionField.text = @"";
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

- (IBAction)pressedRepresentative:(id)sender {
    self.tableViewRepresentatives.hidden = !(self.tableViewRepresentatives.hidden);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableCell"];
    User *representative = self.representatives[indexPath.row];
    [representative fetch];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableCell"];
    }
    cell.textLabel.text = [representative fullTitleRepresentative];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.representatives.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     [self.representativeButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
     self.currentRepresentative = self.representatives[indexPath.row];
     tableView.hidden = YES;
}



//#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//}

@end

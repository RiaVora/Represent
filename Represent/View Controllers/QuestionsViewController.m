//
//  QuestionsViewController.m
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "QuestionsViewController.h"


@interface QuestionsViewController () <UITableViewDelegate, UITableViewDataSource, QuestionCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *questions;
@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITableView *tableViewRepresentatives;
@property (weak, nonatomic) IBOutlet UIButton *representativeButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *availableVotesLabel;

@end

@implementation QuestionsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
//    [User logOut];
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [self setUpTableViews];
    [self setUpViews];
//        [self postTestQuestion:@"i really have to know"];
//        [self postTestQuestion:@"thank you for your service"];
    [self fetchQuestions];
    [self initRefreshControl];
    [MBProgressHUD hideHUDForView:self.view animated:true];

    
}

#pragma mark - Setup

- (void)setUpTableViews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableViewRepresentatives.delegate = self;
    self.tableViewRepresentatives.dataSource = self;
    self.tableViewRepresentatives.hidden = YES;
    self.tableViewRepresentatives.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setUpViews {
    self.currentUser = [User currentUser];
    [self.currentUser updateAvailableVotes];
    [self.availableVotesLabel setText:[NSString stringWithFormat:@"%@", self.currentUser.availableVoteCount]];
    if (!self.currentRepresentative) {
        self.currentRepresentative = self.currentUser.followedRepresentatives[0];
        [self.currentRepresentative fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error with fetching representative %@", error.localizedDescription);
            } else {
                [self.representativeButton setTitle:[self.currentRepresentative fullTitleRepresentative] forState:UIControlStateNormal];
            }
        }];
    } else {
        [self.representativeButton setTitle:[self.currentRepresentative fullTitleRepresentative] forState:UIControlStateNormal];
    }
}

- (void)initRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchQuestions) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

#pragma mark - Data Query

- (void)fetchQuestions {
    PFQuery *questionQuery = [Question query];
    [questionQuery orderByDescending:@"voteCount"];
    [questionQuery includeKey:@"author"];
    [questionQuery includeKey:@"representative"];
    [questionQuery whereKey:@"representative" equalTo:self.currentRepresentative];
    questionQuery.limit = 40;
    
    [questionQuery findObjectsInBackgroundWithBlock:^(NSArray<Question *> * _Nullable questions, NSError * _Nullable error) {
        if (questions) {
            NSLog(@"Successfully received questions!");
            self.questions = [NSMutableArray arrayWithArray:questions];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"There was a problem fetching Questions: %@", error.localizedDescription);
        }
    }];
}

- (void)fetchMoreQuestions: (BOOL)justPosted {
    PFQuery *questionQuery = [Question query];
    [questionQuery orderByDescending:@"voteCount"];
    [questionQuery includeKey:@"author"];
    [questionQuery includeKey:@"representative"];
    [questionQuery whereKey:@"representative" equalTo:self.currentRepresentative];
    questionQuery.skip = self.questions.count;
    
    [questionQuery findObjectsInBackgroundWithBlock:^(NSArray<Question *> * _Nullable questions, NSError * _Nullable error) {
        if (questions) {
            NSLog(@"Successfully received more questions!");
            for (Question *question in questions) {
                [self.questions addObject:question];
            }
            [self.tableView reloadData];
            if (justPosted) {
                [self goToCell:(int)self.questions.count - 1];
            }

        } else {
            NSLog(@"There was a problem fetching more Questions: %@", error.localizedDescription);
        }
    }];
}

- (void)goToCell: (int)row {
    NSIndexPath *newQuestionPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView scrollToRowAtIndexPath: newQuestionPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    QuestionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"QuestionCell" forIndexPath:newQuestionPath];
    [cell setSelected:YES animated:YES];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
        cell.question = self.questions[indexPath.row];
        cell.controllerDelegate = self;
        cell.delegate = self;
        [cell updateValues: indexPath.row];
        return cell;
    } else {
        RepresentativeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepresentativeCell"];
        if (cell == nil) {
            cell = [[RepresentativeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RepresentativeCell"];
        }
        User *representative = self.currentUser.followedRepresentatives[indexPath.row];
        [representative fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error with fetching representative from array %@", error.localizedDescription);
            } else {
                cell.representative = representative;
                [cell updateValues];
            }
        }];
        
        return cell;
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return self.questions.count;
    } else {
        return self.currentUser.followedRepresentatives.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableViewRepresentatives]) {
        RepresentativeCell *cell = [self.tableViewRepresentatives cellForRowAtIndexPath:indexPath];
        [self.representativeButton setTitle:[cell.representative fullTitleRepresentative] forState:UIControlStateNormal];
        self.currentRepresentative = cell.representative;
        self.tableViewRepresentatives.hidden = YES;
        [self fetchQuestions];
    }
}

#pragma mark - Actions

- (IBAction)pushedRepresentative:(id)sender {
    self.tableViewRepresentatives.hidden = !(self.tableViewRepresentatives.hidden);
}

- (IBAction)pressedUsername:(id)sender {
    [self performSegueWithIdentifier:@"profileSegue" sender:sender];
}

#pragma mark - QuestionCellDelegate

- (void)didVote:(Question *)question {
    [self fetchQuestions];
    [self.availableVotesLabel setText:[NSString stringWithFormat:@"%@", self.currentUser.availableVoteCount]];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"postQuestionSegue"]) {
        [self postQuestionSegue:segue sender:sender];
    } else if ([segue.identifier isEqualToString:@"profileSegue"]) {
        [self profileSegue:segue sender:sender];
    }

}

- (void)postQuestionSegue: (UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    PostQuestionsViewController *postQuestionsVC = (PostQuestionsViewController*)navigationController.topViewController;
    postQuestionsVC.currentRepresentative = self.currentRepresentative;
}

- (void)profileSegue: (UIStoryboardSegue *)segue sender:(id)sender {
    ProfileViewController *profileVC = [segue destinationViewController];
    QuestionCell *cell = (QuestionCell*)[[sender superview] superview];
    profileVC.user = cell.question.author;
}


- (IBAction) pressedPost:(UIStoryboardSegue *)unwindSegue {
    PostQuestionsViewController *postQuestionsVC = [unwindSegue sourceViewController];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *questionText = [postQuestionsVC pressedPost];
    self.currentRepresentative = postQuestionsVC.currentRepresentative;
    if (questionText) {
        [self postQuestion: questionText];
    }


}

- (void)postQuestion: (NSString *)questionText {
    [Question postUserQuestion:questionText forRepresentative:self.currentRepresentative withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"Error posting question: %@", error.localizedDescription);
            [Utils displayAlertWithOk:@"Error with Posting Question" message:error.localizedDescription viewController:self];
        } else {
            NSLog(@"Successfully posted Question %@ for %@!", questionText, self.currentRepresentative.username);
            [self setUpViews];
            [self fetchMoreQuestions:YES];
            [MBProgressHUD hideHUDForView:self.view animated:true];
        }
    }];
}

#pragma mark - Helpers

- (void)postTestQuestion: (NSString *)text {
    for (User *representative in self.currentUser.followedRepresentatives) {
        [representative fetch];
        [Question postUserQuestion:[NSString stringWithFormat: @"%@ for %@", text, representative.firstName] forRepresentative:representative withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Question successfully saved!");
            } else {
                NSLog(@"Unable to save question: %@", error.localizedDescription);
            }
        }];
    }
}


@end

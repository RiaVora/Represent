//
//  QuestionsViewController.m
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "QuestionsViewController.h"
#import "QuestionCell.h"


@interface QuestionsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *questions;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) User *currentRepresentative;
@property (weak, nonatomic) IBOutlet UITableView *tableViewRepresentatives;
@property (weak, nonatomic) IBOutlet UIButton *representativeButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation QuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableViews];
//    [self postTestQuestion:@"i really have to know"];
//    [self postTestQuestion:@"thank you for your service"];
    [self fetchQuestions];
    [self initRefreshControl];
    
}

- (void)setUpTableViews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableViewRepresentatives.delegate = self;
    self.tableViewRepresentatives.dataSource = self;
    self.tableViewRepresentatives.hidden = YES;
    self.currentUser = [User currentUser];
    self.currentRepresentative = [self.currentUser.followedRepresentatives[0] fetch];
    [self.representativeButton setTitle:[self.currentRepresentative fullTitleRepresentative] forState:UIControlStateNormal];
}

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

- (void)fetchQuestions {
    PFQuery *questionQuery = [Question query];
    [questionQuery orderByAscending:@"voteCount"];
    [questionQuery includeKey:@"author"];
    [questionQuery includeKey:@"representative"];
    [questionQuery whereKey:@"representative" equalTo:self.currentRepresentative];
    questionQuery.limit = 40;
    
    [questionQuery findObjectsInBackgroundWithBlock:^(NSArray<Question *> * _Nullable questions, NSError * _Nullable error) {
        if (questions) {
            NSLog(@"Successfully received questions!");
            for (Question *question in questions) {
                NSLog(@"Representative for question is %@", question.representative.firstName);
            }
            self.questions = [NSMutableArray arrayWithArray:questions];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            
        } else {
            NSLog(@"There was a problem fetching Questions: %@", error.localizedDescription);
        }
    }];
}

- (void)initRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchQuestions) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
        cell.question = self.questions[indexPath.row];
        [cell updateValues];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableCell"];
        User *representative = self.currentUser.followedRepresentatives[indexPath.row];
        [representative fetch];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableCell"];
        }
        NSString *fullName = [NSString stringWithFormat:@"%@ %@ %@", representative.shortPosition, representative.firstName, representative.lastName];
        cell.textLabel.text = fullName;
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
        UITableViewCell *cell = [self.tableViewRepresentatives cellForRowAtIndexPath:indexPath];
        [self.representativeButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.currentRepresentative = self.currentUser.followedRepresentatives[indexPath.row];
        self.tableViewRepresentatives.hidden = YES;
        [self fetchQuestions];
    }
}
- (IBAction)pushedRepresentative:(id)sender {
    self.tableViewRepresentatives.hidden = !(self.tableViewRepresentatives.hidden);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

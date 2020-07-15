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

@end

@implementation QuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self postTestQuestion:@"hello world!"];
//    [self postTestQuestion:@"another question for you greedy people"];
    [self fetchQuestions];
    
}

- (void)postTestQuestion: (NSString *)text {
    [Question postUserQuestion:text forRepresentative:[User currentUser].followedRepresentatives[0] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Question successfully saved!");
        } else {
            NSLog(@"Unable to save question: %@", error.localizedDescription);
        }
    }];
}

- (void)fetchQuestions {
    PFQuery *questionQuery = [Question query];
    [questionQuery orderByAscending:@"voteCount"];
    [questionQuery includeKey:@"author"];
    questionQuery.limit = 40;
    
    [questionQuery findObjectsInBackgroundWithBlock:^(NSArray<Question *> * _Nullable questions, NSError * _Nullable error) {
        if (questions) {
            NSLog(@"Successfully received questions!");
            for (Question *question in questions) {
                NSLog(@"this questions asks %@", question.text);
            }
            
            self.questions = [NSMutableArray arrayWithArray:questions];
            [self.tableView reloadData];
            
        } else {
            NSLog(@"There was a problem fetching Questions: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
    cell.question = self.questions[indexPath.row];
    [cell updateValues];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questions.count;
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

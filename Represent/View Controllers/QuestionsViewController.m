//
//  QuestionsViewController.m
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "QuestionsViewController.h"
#import "User.h"
#import "Question.h"

@interface QuestionsViewController ()

@end

@implementation QuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    User *currentUser = [User currentUser];
//    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"User %@ successfully saved!", currentUser.username);
//        } else {
//            NSLog(@"User %@ could not be saved: %@", currentUser.username, error.localizedDescription);
//        }
//    }];
    // Do any additional setup after loading the view.
}

- (void)fetchQuestions {
    PFQuery *questionQuery = [Question query];
    [questionQuery orderByAscending:@"voteCount"];
    [questionQuery includeKey:@"author"];
    questionQuery.limit = 20;
    
    [questionQuery findObjectsInBackgroundWithBlock:^(NSArray<Question *> * _Nullable questions, NSError * _Nullable error) {
        if (questions) {
            NSLog(@"Successfully received questions!");
            for (Question *question in questions) {
                NSLog(@"this questions asks %@", question.text);
            }
        } else {
            NSLog(@"There was a problem fetching Questions: %@", error.localizedDescription);
        }
    }];
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

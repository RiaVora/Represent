//
//  ViewController.m
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "ViewController.h"
#import "Question.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Question postUserQuestion:@"test question" forRepresentative:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Question successfully saved!");
        } else {
            NSLog(@"Unable to save question: %@", error.localizedDescription);
        }
    }];
    PFQuery *questionQuery = [Question query];
    [questionQuery orderByDescending:@"createdAt"];
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



@end

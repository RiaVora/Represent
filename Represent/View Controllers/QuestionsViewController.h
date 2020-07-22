//
//  QuestionsViewController.h
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Question.h"
#import "QuestionCell.h"
#import "PostQuestionsViewController.h"
#import "MBProgressHUD.h"
#import "RepresentativeCell.h"
#import "ProfileViewController.h"

/*The QuestionsViewController is a UIViewController class that is used to display questions for the user to vote on. The page has a dropdown menu to toggle through representatives, and consists of a main TableView that displays QuestionCells. The view also implements UIRefreshControl.*/

NS_ASSUME_NONNULL_BEGIN

@interface QuestionsViewController : UIViewController

@property (strong, nonatomic) User *currentRepresentative;

@end

NS_ASSUME_NONNULL_END

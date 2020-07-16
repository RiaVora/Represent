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

NS_ASSUME_NONNULL_BEGIN

@interface QuestionsViewController : UIViewController

@property (strong, nonatomic) User *currentRepresentative;

@end

NS_ASSUME_NONNULL_END

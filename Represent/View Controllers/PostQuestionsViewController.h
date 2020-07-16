//
//  PostQuestionsViewController.h
//  Represent
//
//  Created by Ria Vora on 7/16/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Question.h"
#import <Parse/Parse.h>
#import "Utils.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostQuestionsViewController : UIViewController

@property (strong, nonatomic) User *currentRepresentative;

@end

NS_ASSUME_NONNULL_END

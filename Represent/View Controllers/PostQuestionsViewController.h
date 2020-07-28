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
#import "MBProgressHUD.h"
#import "QuestionsViewController.h"

NS_ASSUME_NONNULL_BEGIN

/*The PostQuestionsViewController is a UIViewController class that is used to accept user input of a question and post it as the currently logged-in user. The page consists of a main view that displays a UITextView for the User to type in and a dropdown menu of Representatives to post. The PostQuestionsViewController sends the representative that was posted to the QuestionsViewController, and the post shows without refreshing.*/

@interface PostQuestionsViewController : UIViewController

/*The current representative on the representative menu of the QuestionsViewController, passed in to maintain consistency for the PostQuestionsViewController.*/
@property (strong, nonatomic) User *currentRepresentative;

/*Returns the string of the new question for the QuestionsViewController.*/
- (NSString *)pressedPost;

@end

NS_ASSUME_NONNULL_END

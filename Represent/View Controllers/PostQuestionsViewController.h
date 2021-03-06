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

@protocol PostQuestionsDelegate

/*Is called in the QuestionsViewController to update the voteCount when a user votes.
 
 @param question is the Question represented in the QuestionCell where the vote button was tapped
 */
- (void)didPost:(NSString *)questionText: (User *)currrentRepresentative;

@end

@interface PostQuestionsViewController : UIViewController

/*PROPERTIES*/

/*The current representative on the representative menu of the QuestionsViewController, passed in to maintain consistency for the PostQuestionsViewController.*/
@property (strong, nonatomic) User *currentRepresentative;

/*Part of the PostQuestionsDelegate implementation, and is assigned externally by the QuestionsViewController.*/
@property (nonatomic, weak) id<PostQuestionsDelegate> delegate;

/*METHODS*/

/*Returns the string of the new question for the QuestionsViewController.
 
 @return the text of the new posted question
 */
//- (NSString *)pressedPost;

@end

NS_ASSUME_NONNULL_END

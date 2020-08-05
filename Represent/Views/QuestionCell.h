//
//  QuestionCell.h
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "DateTools.h"
#import <ChameleonFramework/Chameleon.h>

/*The QuestionCell class is a UITableViewCell class that is used to represent one question on the TableView in the QuestionsViewController. The QuestionCell sets it's labels, photo, etc. to the respective values from the Question passed in from the QuestionsViewController. The QuestionCell also interacts with the Vote button to save voting.*/

NS_ASSUME_NONNULL_BEGIN

@protocol QuestionCellDelegate

/*Is called in the QuestionsViewController to update the voteCount when a user votes.
 
 @param question is the Question represented in the QuestionCell where the vote button was tapped
 */
- (void)didVote:(Question *)question;

@end

@interface QuestionCell : UITableViewCell

/*PROPERTIES*/

/*Represents the question associated with this QuestionCell, and is assigned externally by the QuestionsViewController.
 */
@property (strong, nonatomic) Question *question;

/*Represents the outside view and is used to send alerts. Is assigned externally by the QuestionsViewController.*/
@property (nonatomic, weak) __kindof UIViewController *controllerDelegate;

/*Part of the QuestionCellDelegate implementation, and is assigned externally by the QuestionsViewController.*/
@property (nonatomic, weak) id<QuestionCellDelegate> delegate;

/*METHODS*/

/*Used to update the labels, buttons, and views in the QuestionCell, and is called externally by the QuestionsViewController.
 
 @param row is the index row of the question, used to determine if the question is in the top 3 and should be highlighted
 */
- (void)updateValues: (NSInteger)row;

@end

NS_ASSUME_NONNULL_END

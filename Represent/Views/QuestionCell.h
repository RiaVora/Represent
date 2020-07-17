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

/*The QuestionCell class is a UITableViewCell class that is used to represent one question on the TableView in the QuestionsViewController. The QuestionCell sets it's labels, photo, etc. to the respective values from the Question passed in from the QuestionsViewController. The QuestionCell also interacts with the Vote button to save voting.*/

NS_ASSUME_NONNULL_BEGIN

@protocol QuestionCellDelegate

- (void)didVote:(Question *)question;

@end

@interface QuestionCell : UITableViewCell

@property (strong, nonatomic) Question *question;
@property (nonatomic, weak) __kindof UIViewController *controllerDelegate;
@property (nonatomic, weak) id<QuestionCellDelegate> delegate;
- (void)updateValues: (NSInteger)row;

@end

NS_ASSUME_NONNULL_END

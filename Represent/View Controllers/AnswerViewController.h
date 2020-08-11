//
//  AnswerViewController.h
//  Represent
//
//  Created by Ria Vora on 8/5/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "User.h"
#import "Utils.h"
#import "DateTools.h"
#import "MBProgressHUD.h"
#import <ChameleonFramework/Chameleon.h>
#import "ProfileViewController.h"

/*The AnswerViewController is a UIViewController class consisting of a section where the Question is displayed and either an area for the representative to answer (if the user is the representative that the question is directed to) or a static view of the answer from the representative. The segue from QuestionsViewController to AnswerViewController is given to the representative at all times, and to other users only if the question has been answered.*/

NS_ASSUME_NONNULL_BEGIN

@interface AnswerViewController : UIViewController

/*PROPERTIES*/

/*The question sent through the segue with the QuestionsViewController that the representative will be answering.*/
@property (strong, nonatomic) Question *question;

@end

NS_ASSUME_NONNULL_END

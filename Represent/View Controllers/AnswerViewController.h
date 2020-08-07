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

NS_ASSUME_NONNULL_BEGIN

@interface AnswerViewController : UIViewController

/*PROPERTIES*/

/*The question sent through the segue with the QuestionsViewController that the representative will be answering.*/
@property (strong, nonatomic) Question *question;

@end

NS_ASSUME_NONNULL_END

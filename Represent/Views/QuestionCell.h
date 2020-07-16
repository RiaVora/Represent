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

NS_ASSUME_NONNULL_BEGIN

@interface QuestionCell : UITableViewCell

@property (strong, nonatomic) Question *question;
@property (nonatomic, weak) __kindof UIViewController *controllerDelegate;
- (void)updateValues;

@end

NS_ASSUME_NONNULL_END

//
//  RepresentativeCell.h
//  Represent
//
//  Created by Ria Vora on 7/16/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

/*The RepresentativeCell class is a UITableViewCell class that is used to represent one representative on the TableView in the QuestionsViewController/PostQuestionsViewController. The RepresentativeCell sets it's label to the name of the representative passed in from either ViewController.*/


NS_ASSUME_NONNULL_BEGIN

@interface RepresentativeCell : UITableViewCell

/*PROPERTIES*/

/*Is the RepresentativeCell's given representative, assigned externally by the QuestionsViewController and PostQuestionsViewController.*/
@property (strong, nonatomic) User *representative;


/*METHODS*/

/*Used to update the name label in the RepresentativeCell, called externally by the QuestionsViewController and the PostQuestionsViewController.*/
- (void)updateValues;

@end

NS_ASSUME_NONNULL_END

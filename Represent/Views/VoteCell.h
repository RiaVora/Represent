//
//  VoteCell.h
//  Represent
//
//  Created by Ria Vora on 7/24/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Utils.h"
#import "Bill.h"
#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface VoteCell : UICollectionViewCell

/*PROPERTIES*/

/*The bill displayed on the BillCell that houses this VoteCell, assigned externally by the BillCell, and used to find the vote of the given representative.*/
@property (strong, nonatomic) Bill *bill;

/*The specific representative that this VoteCell displays, assigned externally by the BillCell.*/
@property (strong, nonatomic) User *representative;

/*METHODS*/

/*Used to update the various labels and images, called externally by the BillCell.*/
- (void)updateValues;

@end

NS_ASSUME_NONNULL_END

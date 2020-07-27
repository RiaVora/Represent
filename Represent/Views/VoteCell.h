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

@property (strong, nonatomic) Bill *bill;
@property (strong, nonatomic) User *representative;

- (void)updateValues;

@end

NS_ASSUME_NONNULL_END

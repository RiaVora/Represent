//
//  BillCell.h
//  Represent
//
//  Created by Ria Vora on 7/17/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"
#import "APIManager.h"
#import "User.h"
#import "DateTools.h"
#import "VoteCell.h"

/*The BillCell class is a UITableViewCell class that is used to represent one bill on the TableView in the BillsViewController. The BillCell sets it's bill information to the bill passed in from the BillViewController and displays votes based on data from the API.*/


NS_ASSUME_NONNULL_BEGIN

@interface BillCell : UITableViewCell

@property (strong, nonatomic) Bill *bill;

- (void)updateValues;

@end

NS_ASSUME_NONNULL_END

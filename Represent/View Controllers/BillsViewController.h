//
//  BillsViewController.h
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "APIManager.h"
#import "Bill.h"
#import "BillCell.h"

/*The BillsViewController is a UIViewController class that is used to display bills for the user to vote on. The page consists of a main TableView that displays BillCells with votes from relevant representatives, and it implements UIRefreshControl.*/

NS_ASSUME_NONNULL_BEGIN

@interface BillsViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

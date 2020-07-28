//
//  BillDetailsController.h
//  Represent
//
//  Created by Ria Vora on 7/20/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"
#import "DateTools.h"
#import "BillCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BillDetailsViewController : UIViewController

/*The bill of the cell that was tapped in the BillsViewController, used to pass the bill and its information to the detailed view.*/
@property (strong, nonatomic) Bill *bill;

@end

NS_ASSUME_NONNULL_END

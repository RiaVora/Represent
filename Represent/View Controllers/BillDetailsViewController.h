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

NS_ASSUME_NONNULL_BEGIN

@interface BillDetailsViewController : UIViewController

@property (strong, nonatomic) Bill *bill;

@end

NS_ASSUME_NONNULL_END

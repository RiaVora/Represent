//
//  RepresentativeCell.h
//  Represent
//
//  Created by Ria Vora on 7/16/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface RepresentativeCell : UITableViewCell

@property (strong, nonatomic) User *representative;

- (void)updateValues;

@end

NS_ASSUME_NONNULL_END

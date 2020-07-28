//
//  BillCell.m
//  Represent
//
//  Created by Ria Vora on 7/17/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "BillCell.h"



@interface BillCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesForLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesAgainstLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesAbstainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSMutableArray *reccomendedReps;


@end

@implementation BillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.user = [User currentUser];
    self.reccomendedReps = [[NSMutableArray alloc] init];
}

- (void)setUpCollectionView {
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)
//    self.collectionView.collectionViewLayout;
    
//    layout.minimumInteritemSpacing = 5;
//    layout.minimumLineSpacing = 5;
//    CGFloat votesPerLine = 6;
//    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (votesPerLine - 1)) / votesPerLine;
//    CGFloat itemHeight = 1.5 * itemWidth;
//    
//    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)updateValues {
    if (self.collectionView) {
        [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    }
    self.titleLabel.text = self.bill.title;
    if (self.bill.shortSummary) {
        self.shortSummaryLabel.text = self.bill.shortSummary;
    } else {
        self.shortSummaryLabel.text = @"";
    }
    [Utils setResultLabel:self.bill.result forLabel:self.resultLabel];
    if ([self.resultLabel.textColor isEqual:UIColor.systemGreenColor]) {
        [self.resultImageView setHighlighted:NO];
        [self.resultImageView setTintColor:UIColor.systemGreenColor];
    } else {
        [self.resultImageView setHighlighted:YES];
        [self.resultImageView setTintColor:UIColor.systemRedColor];
    }

    self.timestampLabel.text = [NSString stringWithFormat:@"%@", self.bill.date.timeAgoSinceNow];
    if ([self.bill.type isEqualToString:@"House"]) {
        self.typeLabel.text = @"House of Representatives";
    } else {
        self.typeLabel.text = self.bill.type;
    }
    
    self.votesForLabel.text = [NSString stringWithFormat:@"%ld", (long)self.bill.votesFor.count];
    self.votesAgainstLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesAgainst.count];
    self.votesAbstainLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesAbstain.count];
    BOOL cont = [self.bill.type isEqualToString:@"Senate"];
    if (cont) {
        [self updateVotesSenate];
        NSLog(@"This bill %@ is of type %@ and ran for Senate", self.bill.title, self.bill.type);
        NSLog(@"Representatives array is %@", self.reccomendedReps);
    } else {
        [self updateVotesHouse];
//        NSLog(@"This bill %@ is of type %@ and ran for House", self.bill.title, self.bill.type);
//        NSLog(@"Representatives array is %@", self.reccomendedReps);
    }

}

- (void)updateVotesSenate {
    for (User *followedRep in self.user.followedRepresentatives) {
        [followedRep fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable followedRep, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error with fetching representative in followed Reps %@", error.localizedDescription);
            } else {
                User *followedRepresentative = (User *)followedRep;
                if ([followedRepresentative.shortPosition isEqualToString:@"Sen."] && ![self hasRep:followedRepresentative]) {
                    [self.reccomendedReps addObject:followedRep];
                }
            }
        }];
        
    }
    [self.bill.sponsor fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable sponsor, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with fetching sponsor: %@", error.localizedDescription);
        } else {
            if (![self hasRep:self.bill.sponsor]) {
                [self.reccomendedReps addObject:sponsor];
            }
        }
    }];
    [self.collectionView reloadData];
    [MBProgressHUD hideHUDForView:self.collectionView animated:YES];

}

- (BOOL)hasRep: (User *)newRep {
    for (User *rep in self.reccomendedReps) {
        if ([rep.representativeID isEqualToString:newRep.representativeID]) {
            return YES;
        }
    }
    return NO;
}

- (void)updateVotesHouse {
    PFQuery *userQuery = [User query];
    userQuery.limit = 20;
    [userQuery whereKey:@"state" matchesText:self.user.state];
    [userQuery whereKey:@"isRepresentative" equalTo:@(YES)];
    [userQuery whereKey:@"shortPosition" containsString:@"Rep"];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable reps, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with finding reps in this state: %@", error.localizedDescription);
        } else {
            [self.reccomendedReps addObjectsFromArray:reps];
            [self.collectionView reloadData];
            [MBProgressHUD hideHUDForView:self.collectionView animated:YES];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VoteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VoteCell" forIndexPath:indexPath];
    cell.bill = self.bill;
    cell.representative = self.reccomendedReps[indexPath.row];
    cell.layer.borderColor =  UIColor.lightGrayColor.CGColor;
    cell.layer.borderWidth = 1;
    cell.layer.cornerRadius = 10;
    [cell updateValues];
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.reccomendedReps.count;
}

@end

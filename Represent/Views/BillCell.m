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

- (void)updateValues {
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
    [self updateVotes:self.bill.type withCompletion:^(BOOL success) {
        if (!success) {
            NSLog(@"Error with finding reccomended representatives");
        } else {
            [self.collectionView reloadData];
        }
    }];
    
    
}



- (void)updateVotes: (NSString *)type withCompletion:(void(^)(BOOL success))completion {
    [self addFollowed:type];
    [self addSponsor];
    [self addRelevant:type withCompletion:^(BOOL success) {
        completion(success);
    }];
}

- (void)addSponsor {
    [self.bill.sponsor fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable sponsor, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with fetching sponsor: %@", error.localizedDescription);
        } else {
            if (![self hasRep:self.bill.sponsor]) {
                [self.reccomendedReps addObject:sponsor];
            }
        }
    }];
}


- (void)addFollowed: (NSString *)type {
    NSString *shortPosition = @"Rep.";
    if ([type isEqualToString:@"Senate"]) {
        shortPosition = @"Sen.";
    }
    for (User *followedRep in self.user.followedRepresentatives) {
        [followedRep fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable followedRep, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error with fetching representative in followed Reps %@", error.localizedDescription);
            } else {
                User *followedRepresentative = (User *)followedRep;
                if ([followedRepresentative.shortPosition isEqualToString:shortPosition] && ![self hasRep:followedRepresentative]) {
                    [self.reccomendedReps addObject:followedRep];
                }
            }
        }];
        
    }
}

- (void)addRelevant: (NSString *)type withCompletion:(void(^)(BOOL success))completion {
    PFQuery *userQuery = [User query];
    userQuery.limit = 10;
    NSString *shortPosition = @"Rep.";
    if ([type isEqualToString:@"Senate"]) {
        shortPosition = @"Sen.";
    } else {
        [userQuery whereKey:@"state" matchesText:self.user.state];
    }
    [userQuery whereKey:@"isRepresentative" equalTo:@(YES)];
    [userQuery whereKey:@"shortPosition" containsString:shortPosition];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable reps, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with finding reps in this state: %@", error.localizedDescription);
            completion(NO);
        } else {
            for (User *rep in reps) {
                if (![self hasRep:rep]) {
                    [self.reccomendedReps addObjectsFromArray:reps];
                }
            }
            completion(YES);
        }
    }];
}


- (BOOL)hasRep: (User *)newRep {
    for (User *rep in self.reccomendedReps) {
        if ([rep.representativeID isEqualToString:newRep.representativeID]) {
            return YES;
        }
    }
    return NO;
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

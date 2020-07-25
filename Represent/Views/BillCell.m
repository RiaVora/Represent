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
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *votes;
@property (strong, nonatomic) User *user;


@end

@implementation BillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.user = [User currentUser];
    self.votes = [[NSMutableArray alloc] init];
    [self setUpCollectionView];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)
    self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    CGFloat votesPerLine = 6;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (votesPerLine - 1)) / votesPerLine;
    CGFloat itemHeight = 1.5 * itemWidth;
    
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)updateValues {
    self.titleLabel.text = self.bill.title;
    if (self.bill.shortSummary) {
        self.shortSummaryLabel.text = self.bill.shortSummary;
    } else {
        self.shortSummaryLabel.text = @"";
    }
    [Utils setResultLabel:self.bill.result forLabel:self.resultLabel];
    

    self.timestampLabel.text = [NSString stringWithFormat:@"%@", self.bill.date.timeAgoSinceNow];
    if ([self.bill.type isEqualToString:@"House"]) {
        self.typeLabel.text = @"House of Representatives";
    } else {
        self.typeLabel.text = self.bill.type;
    }
    
    self.votesForLabel.text = [NSString stringWithFormat:@"%ld", (long)self.bill.votesFor];
    self.votesAgainstLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesAgainst];
    self.votesAbstainLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesAbstain];

    BOOL cont = [self.bill.type isEqualToString:@"Senate"];
    if (cont) {
        [self updateVotes];
    } else {
        self.collectionView.hidden = YES;
    }

}

- (void)updateVotes {
    APIManager *manager = [APIManager new];
    [manager fetchVotes:self.bill.votesURL :^(NSArray * _Nonnull votes, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error with fetching votes from API");
        } else {
            NSLog(@"Success with fetching votes from API!");
            for (User *rep in self.user.followedRepresentatives) {
                NSArray *filteredData = [votes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(member_id ==[c]%@)", rep.representativeID]];
                [self.votes addObject:filteredData[0]];
            }            
            [self.collectionView reloadData];

        }
    }];
    
}

#pragma mark - UICollectionViewDataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VoteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VoteCell" forIndexPath:indexPath];
    cell.vote = self.votes[indexPath.row];
    cell.representative = self.user.followedRepresentatives[indexPath.row];
    cell.layer.borderColor =  UIColor.lightGrayColor.CGColor;
    cell.layer.borderWidth = 1;
    cell.layer.cornerRadius = 10;
    [cell updateValues];
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.votes.count;
}

@end

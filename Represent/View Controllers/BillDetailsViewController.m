//
//  BillDetailsController.m
//  Represent
//
//  Created by Ria Vora on 7/20/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "BillDetailsViewController.h"

@interface BillDetailsViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesForLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesAgainstLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesAbstainLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *bills;

@end

@implementation BillDetailsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setBackgroundView:nil];

    self.bills = [[NSMutableArray alloc] init];
    [self updateValues];
    [self fetchBills];
}

#pragma mark - Setup

- (void)updateValues {
    self.titleLabel.text = self.bill.title;
    if (self.bill.shortSummary) {
        self.summaryLabel.text = self.bill.shortSummary;
    } else {
        self.summaryLabel.text = @"";
    }
    [Utils setResultLabel:self.bill.result forLabel:self.resultLabel];
    self.timestampLabel.text = [NSString stringWithFormat:@"%@", self.bill.date.timeAgoSinceNow];
    self.votesForLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesFor.count];
    self.votesAgainstLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesAgainst.count];
    self.votesAbstainLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesAbstain.count];
}

#pragma mark - Data Query

- (void)fetchBills {
    PFQuery *billQuery = [Bill query];
    [billQuery whereKey:@"billID" equalTo:self.bill.billID];
    [billQuery whereKey:@"headBill" equalTo:@(NO)];
    [billQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable bills, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with fetching similar bills: %@", error.localizedDescription);
        } else {
            self.bills = [NSMutableArray arrayWithArray:bills];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillCell"];
    cell.bill = self.bills[indexPath.row];
    [cell updateValues];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bills.count;
}

#pragma mark - DZEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    UIImage *resizedImage = [Utils resizeImage:[UIImage systemImageNamed:@"book"] withSize:CGSizeMake(100, 100)];
    resizedImage = [resizedImage imageWithTintColor:UIColor.systemGrayColor];
    return resizedImage;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No Past Actions";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:25.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"This bill doesn't have any past actions!";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end

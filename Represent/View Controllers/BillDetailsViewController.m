//
//  BillDetailsController.m
//  Represent
//
//  Created by Ria Vora on 7/20/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "BillDetailsViewController.h"

@interface BillDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.bills = [[NSMutableArray alloc] init];
    [self updateValues];
    [self fetchBills];
}

- (void)updateValues {
    self.titleLabel.text = self.bill.title;
    if (self.bill.shortSummary) {
        self.summaryLabel.text = self.bill.shortSummary;
    } else {
        self.summaryLabel.text = @"";
    }
    
    self.resultLabel.text = self.bill.result;
    self.resultLabel.textColor = UIColor.systemGreenColor;
    self.timestampLabel.text = [NSString stringWithFormat:@"%@", self.bill.date.timeAgoSinceNow];
    self.votesForLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesFor];
    self.votesAgainstLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesAgainst];
    self.votesAbstainLabel.text = [NSString stringWithFormat:@"%ld", self.bill.votesAbstain];
}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillCell"];
    cell.bill = self.bills[indexPath.row];
    [cell updateValues];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bills.count;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

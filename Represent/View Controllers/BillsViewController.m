//
//  BillsViewController.m
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "BillsViewController.h"

@interface BillsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *bills;
@property (strong, nonatomic) NSDate *lastRefreshed;
@property (nonatomic) int offset;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation BillsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.offset = 0;
    self.bills = [[NSMutableArray alloc] init];
//    [self initRefreshControl];
    if (self.lastRefreshed.minutesAgo >= 30) {
//        [self updateBills];
    }
    [self fetchBills];
    [self getBillsParse];
}

- (void)fetchBills {
    APIManager *manager = [APIManager new];
    [manager fetchRecentBills:self.offset :^(NSArray * _Nonnull bills, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error with fetching recent bills: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched new bills");
            for (NSDictionary *dictionary in bills) {
                Bill *bill = [Bill createBill:dictionary];
                if (bill) {
                    [self.bills addObject:bill];
                }
            }
            self.offset += 20;
            [self.tableView reloadData];
        }
        
    }];
}

//- (void)updateBills {
//    self.lastRefreshed = [NSDate now];
//    APIManager *manager = [APIManager new];
//    [manager fetchRecentBills:self.offset :^(NSArray * _Nonnull bills, NSError * _Nonnull error) {
//        if (error) {
//            NSLog(@"Error with fetching recent bills: %@", error.localizedDescription);
//        } else {
//            NSLog(@"Successfully fetched new bills");
//            self.bills = [[NSMutableArray alloc] init];
//            for (int i = ((int)bills.count - 1); i >= 0; i--) {
//                [self.bills addObject:[Bill updateBill:bills[i]]];
//            }
//
//            [self.tableView reloadData];
//            [self.refreshControl endRefreshing];
//        }
//    }];
//}

- (void)getBillsParse {
    PFQuery *billQuery = [Bill query];
    [billQuery orderByDescending:@"date"];
    billQuery.limit = 20;
    [billQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable bills, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with fetching bills from Parse: %@", error.localizedDescription);
        } else {
            NSLog(@"Success with fetching bills from Parse!");
            self.bills = [NSMutableArray arrayWithArray:bills];
            [self.tableView reloadData];
        }
    }];
}

- (void)initRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updateBills) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
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

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     BillCell *cell = sender;
     BillDetailsViewController *billDetailsVC = [segue destinationViewController];
     billDetailsVC.bill = cell.bill;
 }

@end

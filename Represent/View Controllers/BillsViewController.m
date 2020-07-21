//
//  BillsViewController.m
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "BillsViewController.h"

@interface BillsViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *bills;
@property (strong, nonatomic) NSDate *lastRefreshed;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

static int OFFSET = 20;

@implementation BillsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.bills = [[NSMutableArray alloc] init];
    [self initRefreshControl];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.isMoreDataLoading = false;
    self.lastRefreshed = [NSDate now];
    [self updateBills];
}

- (void)fetchBills: (BOOL)getNewBills {
    APIManager *manager = [APIManager new];
    int offset = 0;
    if (getNewBills) {
        offset = OFFSET;
    }
    [manager fetchRecentBills:offset :^(NSArray * _Nonnull bills, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error with fetching recent bills: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched new bills");
            for (NSDictionary *dictionary in bills) {
                [Bill updateBills:dictionary];
            }
            [self getBillsParse:getNewBills];
            [MBProgressHUD hideHUDForView:self.view animated:true];
        }
        
    }];
}

- (void)updateBills {
    self.lastRefreshed = [NSDate now];
    [self fetchBills:NO];
}

- (void)getBillsParse: (BOOL)getNewBills {
    PFQuery *billQuery = [Bill query];
    [billQuery orderByDescending:@"date"];
    [billQuery whereKey:@"headBill" equalTo:@(YES)];
    billQuery.limit = 20;
    if (getNewBills) {
        billQuery.skip = self.bills.count;
    }
    [billQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable bills, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with fetching bills from Parse: %@", error.localizedDescription);
        } else {
            NSLog(@"Success with fetching bills from Parse!");
            if (getNewBills) {
                for (Bill *bill in bills) {
                    [self.bills addObject:bill];
                }
                self.isMoreDataLoading = false;
                OFFSET += 20;
            } else {
                self.bills = [NSMutableArray arrayWithArray:bills];
            }
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isMoreDataLoading) {
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        if (scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.isMoreDataLoading = true;
            [self fetchBills:YES];
        }
    }
}

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     BillCell *cell = sender;
     BillDetailsViewController *billDetailsVC = [segue destinationViewController];
     billDetailsVC.bill = cell.bill;
 }

@end

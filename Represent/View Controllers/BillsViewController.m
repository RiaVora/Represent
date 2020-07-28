//
//  BillsViewController.m
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "BillsViewController.h"

@interface BillsViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *bills;
@property (strong, nonatomic) NSMutableArray *filteredBills;
@property (strong, nonatomic) NSDate *lastRefreshed;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) APIManager *manager;
@end

static int OFFSET = 20;

@implementation BillsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [self setUpViews];
    [self getBillsParse:NO];
    [self updateBills];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.lastRefreshed.minutesAgo > 30) {
        [self updateBills];
    }
}


- (void)setUpViews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.bills = [[NSMutableArray alloc] init];
    self.manager = [APIManager new];
    self.isMoreDataLoading = false;
    self.lastRefreshed = [NSDate now];
    [self initRefreshControl];
}


- (void)fetchBills: (BOOL)getNewBills {
    int offset = 0;
    if (getNewBills) {
        offset = OFFSET;
    }
    [self.manager fetchRecentBills:offset :^(NSArray * _Nonnull bills, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error with fetching recent bills: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched new bills");
            [self checkBillsAsync:bills:getNewBills];
        }
        
    }];
   
}

- (void)checkBillsAsync: (NSArray *)bills :(BOOL)getNewBills {
    dispatch_semaphore_t semaphoreGroup = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        int __block uniqueCount = 0;
        for (NSDictionary *dictionary in bills) {
            [Bill updateBills:dictionary withCompletion:^(BOOL isDuplicate, Bill *bill) {
                if (bill) {
                    NSLog(@"Successfully saved bill in for loop");
                    if (!isDuplicate) {
                        NSLog(@"Found unique bill");
                        uniqueCount++;
                    } else {
                        NSLog(@"Found duplicate, did not save bill");
                    }
                } else {
                    NSLog(@"Error with checking existing bills with new bills");
                }
                dispatch_semaphore_signal(semaphoreGroup);
            }];
            
            dispatch_semaphore_wait(semaphoreGroup, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            NSLog(@"Finished queue");
            if (uniqueCount > 0) {
                [self getBillsParse:getNewBills];
            }
            [self.refreshControl endRefreshing];
        });
    });
}

- (void)updateBills {
    self.lastRefreshed = [NSDate now];
    [self fetchBills:NO];
}

- (void)getBillsParse: (BOOL)shouldLoadMore {
    PFQuery *billQuery = [Bill query];
    [billQuery orderByDescending:@"date"];
    [billQuery whereKey:@"headBill" equalTo:@(YES)];
    [billQuery includeKey:@"sponsor"];
    billQuery.limit = 20;
    if (shouldLoadMore) {
        billQuery.skip = self.bills.count;
    }
    [billQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable bills, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with fetching bills from Parse: %@", error.localizedDescription);
        } else {
            NSLog(@"Success with fetching bills from Parse!");
            if (shouldLoadMore) {
                for (Bill *bill in bills) {
                    [self.bills addObject:bill];
                    [self.filteredBills addObject:bill];
                }
                self.isMoreDataLoading = false;
                OFFSET += 20;
            } else if (bills.count > 0) {
                self.bills = [NSMutableArray arrayWithArray:bills];
                self.filteredBills = self.bills;
            }
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            [UIView animateWithDuration:3 animations:^{
                [MBProgressHUD hideHUDForView:self.view animated:true];
            }];
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
    cell.bill = self.filteredBills[indexPath.row];
    [cell updateValues];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredBills.count;
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

#pragma mark - Search Bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length != 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self fetchSearchedBills:searchBar.text];
        
    }
    else {
        self.filteredBills = self.bills;
    }
    
}

- (void)fetchSearchedBills: (NSString *)query {
    [self.manager fetchSearchedBills:query :^(NSArray * _Nonnull bills, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error with fetching searched bills from the API: %@", error.localizedDescription);
        } else {
            NSLog(@"Success with fetching searched bills from API!");
            [self setUpSearchedBills: bills];
        }
    }];
}

- (void)setUpSearchedBills: (NSArray *)bills {
    
    dispatch_semaphore_t semaphoreGroup = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        for (NSDictionary *dictionary in bills) {
            
            [Bill updateBillsFromSearch:dictionary withCompletion:^(Bill * _Nonnull bill) {
                if (bill) {
                    NSLog(@"Found unique bill");
                    self.filteredBills = [[NSMutableArray alloc] init];
                    [self.filteredBills addObject:bill];
                } else {
                    NSLog(@"Error with checking existing bills with new bills");
                }
                dispatch_semaphore_signal(semaphoreGroup);
            }];
            
            dispatch_semaphore_wait(semaphoreGroup, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            NSLog(@"Finished adding searched bills");
            [self.tableView reloadData];
            [UIView animateWithDuration:3 animations:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        });
    });
}


#pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     BillCell *cell = sender;
     BillDetailsViewController *billDetailsVC = [segue destinationViewController];
     billDetailsVC.bill = cell.bill;
 }

@end

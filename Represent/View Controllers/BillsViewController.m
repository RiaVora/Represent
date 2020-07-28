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
@end

static int OFFSET = 20;

@implementation BillsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.bills = [[NSMutableArray alloc] init];
    [self initRefreshControl];
    self.isMoreDataLoading = false;
    self.lastRefreshed = [NSDate now];
    [self getBillsParse:NO];
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
            [self checkBillsAsync:bills:getNewBills];
            
        }
        
    }];
   
}

- (void)checkBillsAsync: (NSArray *)bills :(BOOL)getNewBills {
    dispatch_semaphore_t semaphoreGroup = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        for (NSDictionary *dictionary in bills) {
            [Bill updateBills:dictionary withCompletion:^(BOOL complete) {
                if (complete) {
                    NSLog(@"Successfully saved bill in for loop");
                } else {
                    NSLog(@"Found duplicate, did not save bill");
                }
                dispatch_semaphore_signal(semaphoreGroup);
            }];
            
            dispatch_semaphore_wait(semaphoreGroup, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            NSLog(@"Finished queue");
            [self getBillsParse:getNewBills];
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
            [MBProgressHUD hideHUDForView:self.view animated:true];
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Bill *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject.description containsString:searchText]; }];

        self.filteredBills = [NSMutableArray arrayWithArray:[self.bills filteredArrayUsingPredicate:predicate]];
        
        NSLog(@"%@", self.filteredBills);
        
    }
    else {
        self.filteredBills = self.bills;
    }
    
    [self.tableView reloadData];
 
}

#pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     BillCell *cell = sender;
     BillDetailsViewController *billDetailsVC = [segue destinationViewController];
     billDetailsVC.bill = cell.bill;
 }

@end

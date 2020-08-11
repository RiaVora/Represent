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
@property (weak, nonatomic) IBOutlet UITableView *tableViewFilter;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *bills;
@property (strong, nonatomic) NSMutableArray *filteredBills;
@property (strong, nonatomic) NSDate *lastRefreshed;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) APIManager *manager;
@property (strong, nonatomic) NSMutableArray *filters;
@property (strong, nonatomic) NSString *searchText;

@end

@implementation BillsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [self setUpViews];
    [self fetchBillsParse:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [self fetchBillsParse:NO];
    if (self.lastRefreshed.minutesAgo > 30) {
        [self updateBills];
    }
}

#pragma mark - Setup

- (void)setUpViews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableViewFilter.delegate = self;
    self.tableViewFilter.dataSource = self;
    self.tableViewFilter.tableFooterView = [UIView new];
    self.tableViewFilter.hidden = YES;
    self.searchBar.delegate = self;
    [self.searchBar setImage:[UIImage systemImageNamed:@"line.horizontal.3"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    self.searchText = @"";
    self.bills = [[NSMutableArray alloc] init];
    self.filteredBills = [[NSMutableArray alloc] init];
    self.filters = [[NSMutableArray alloc] init];
    self.manager = [APIManager new];
    self.isMoreDataLoading = false;
    self.lastRefreshed = [NSDate now];
    [self initRefreshControl];
}

- (void)initRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updateBills) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

#pragma mark - Data Query

- (void)fetchBillsAPI {
    [self.manager fetchRecentBills:0 :^(NSArray * _Nonnull bills, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error with fetching recent bills: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched new bills");
            [self checkBillsAsync:bills];
        }
    }];
}

- (void)checkBillsAsync: (NSArray *)bills{
    dispatch_semaphore_t semaphoreGroup = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
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
                [self fetchBillsParse:NO];
            } else {
                [self.refreshControl endRefreshing];
                [UIView animateWithDuration:3 animations:^{
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                }];
            }
        });
    });
}

- (void)updateBills {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.lastRefreshed = [NSDate now];
    [self fetchBillsAPI];
}

- (void)fetchBillsParse: (BOOL)shouldLoadMore {
    PFQuery *billQuery = [self makeQueryWithSearch];
    [billQuery orderByDescending:@"date"];
    [billQuery whereKey:@"headBill" equalTo:@(YES)];
    [self setQueryWithFilters:billQuery];
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
                    self.filteredBills = self.bills;
                }
                self.isMoreDataLoading = false;
            } else {
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

- (PFQuery *)makeQueryWithSearch {
    if (![self.searchText isEqualToString:@""]) {
        NSMutableArray *subqueries = [[NSMutableArray alloc] init];
        PFQuery *titleContains = [Bill query];
        [titleContains whereKey:@"title" matchesRegex:self.searchText modifiers:@"i"];
        PFQuery *descriptionContains = [Bill query];
        [descriptionContains whereKey:@"shortSummary" matchesRegex:self.searchText modifiers:@"i"];
        [subqueries addObjectsFromArray:@[titleContains, descriptionContains]];
        if ([self.searchText containsString:@" "]) {
            NSArray *words = [self.searchText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            words = [words filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
            for (NSString *word in words) {
                PFQuery *titleContainsWord = [Bill query];
                [titleContainsWord whereKey:@"title" matchesRegex:word modifiers:@"i"];
                PFQuery *descriptionContainsWord = [Bill query];
                [descriptionContainsWord whereKey:@"shortSummary" matchesRegex:word modifiers:@"i"];
                [subqueries addObjectsFromArray:@[titleContainsWord, descriptionContainsWord]];
            }
        }
        return [PFQuery orQueryWithSubqueries:subqueries];
    } else {
        return [Bill query];
    }
}

- (void)setQueryWithFilters: (PFQuery *)billQuery {
    if (self.filters.count > 0 && self.filters.count < [Utils getFilterLength]) {
        NSMutableArray *types = [[NSMutableArray alloc] init];
        if ([self.filters containsObject:@"House"]) {
            [types addObject:@"House"];
        }
        if ([self.filters containsObject:@"Senate"]) {
            [types addObject:@"Senate"];
        }
        if (types.count > 0) {
            [billQuery whereKey:@"type" containedIn:types];
        }
        NSMutableArray *results = [[NSMutableArray alloc] init];
        if ([self.filters containsObject:@"Passed"]) {
            [results addObjectsFromArray:@[@"Passed", @"Agreed to"]];
        }
        if ([self.filters containsObject:@"Failed"]) {
            [results addObjectsFromArray:@[@"Failed", @"Rejected"]];
        }
        if (results.count > 0) {
            [billQuery whereKey:@"result" containedIn:results];
        }
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual: self.tableView]) {
        BillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillCell"];
        cell.bill = self.filteredBills[indexPath.row];
        [cell updateValues];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleCell"];
        }
        cell.textLabel.text = [Utils getFilterAt:(int)indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightLight];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual: self.tableView]) {
        return self.filteredBills.count;
    } else {
        return [Utils getFilterLength];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual: self.tableViewFilter]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self updateFilters:cell.textLabel.text forCell:cell];
        self.tableViewFilter.hidden = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self fetchBillsParse:NO];
    }

}

- (void)updateFilters: (NSString *)filter forCell:(UITableViewCell *)cell {
    if ([self.filters containsObject:filter]) {
        [self.filters removeObject:filter];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [self.filters addObject:filter];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isMoreDataLoading) {
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        if (scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.isMoreDataLoading = true;
            [self fetchBillsParse:YES];
        }
    }
}

#pragma mark - Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    if (searchText.length != 0) {
//        NSPredicate *predicateTitle = [NSPredicate predicateWithBlock:^BOOL(Bill *bill, NSDictionary *bindings) {
//            return [bill.title containsString:searchText];
//        }];
//        NSPredicate *predicateSummary = [NSPredicate predicateWithBlock:^BOOL(Bill *bill, NSDictionary *bindings) {
//            return [bill.shortSummary containsString:searchText];
//        }];
//        NSCompoundPredicate *predicateCombined = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicateTitle, predicateSummary]];
//        self.filteredBills = [NSMutableArray arrayWithArray:[self.bills filteredArrayUsingPredicate:predicateCombined]];
        self.searchText  = searchText;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self fetchBillsParse:NO];
    } else {
        self.searchText = @"";
        self.filteredBills = self.bills;
    }
    [self.tableView reloadData];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    self.tableViewFilter.hidden = !(self.tableViewFilter.hidden);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BillCell *cell = sender;
    BillDetailsViewController *billDetailsVC = [segue destinationViewController];
    billDetailsVC.bill = cell.bill;
}

#pragma mark - Helpers

/*Loads in bills in 20 increments with the given @param offset, and used to convert data from the API into bills.*/
- (void)load20Bills: (int)offset{
    [self.manager fetchRecentBills:offset :^(NSArray * _Nonnull bills, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error with fetching recent bills: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully fetched new bills");
            [self createBillsAsync:bills];
        }
    }];
}

/*Used to force execution to be asynchronous (as opposed to at the same time, or synchronous). Each bill requires an operation of determining the head (newest) bill, which requires a query of other bills; therfore, I used a semaphore group to force each bill creation to finish before the next one starts, ensuring that past bills in the array have been saved and are included in the bill query.*/
- (void)createBillsAsync: (NSArray *)bills {
    
    /*Creates the semaaphore group.*/
    dispatch_semaphore_t semaphoreGroup = dispatch_semaphore_create(0);
    
    /*Starts the asynchronous operations using the created semaphore group.*/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        /*For loop to iterate through each bill dictionary inside of the API bills data to turn each bill dictionary into a Parse bill.*/
        for (NSDictionary *billDictionary in bills) {
            
            /*Assigns the dictionary values for each bill dictionary, creates a new Parse object, finds the representative sponsor, and determines whether a duplicate, a non-head bill, or a head bill.*/
            [Bill updateBills:billDictionary withCompletion:^(BOOL isDuplicate, Bill *bill) {
                
                if (bill) {
                    NSLog(@"Successfully saved bill in for loop");
                    
                    /*If the bill is duplicate, then the bill was not saved and the operation of "updateBills" ended early.*/
                    if (!isDuplicate) {
                        NSLog(@"Found unique bill");
                    } else {
                        NSLog(@"Found duplicate, did not save bill");
                    }
                } else {
                    NSLog(@"Error with checking existing bills with new bills");
                }
                
                /*Signals to the semaphore group that the bill has been created, or has been determined to be a duplicate.*/
                dispatch_semaphore_signal(semaphoreGroup);
            }];
            
            /*Tells the execution semaphore group to wait until a signal before continuing to the next iteration of the for loop (AKA the creation of the next bill).*/
            dispatch_semaphore_wait(semaphoreGroup, DISPATCH_TIME_FOREVER);
        }
        
        /*After the entire asynchronous operation is complete, this block is performed.*/
        dispatch_async(dispatch_get_main_queue(), ^(void){
            NSLog(@"Finished queue");
            [UIView animateWithDuration:3 animations:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        });
    });
}

@end

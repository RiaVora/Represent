//
//  ContactViewController.m
//  Represent
//
//  Created by Ria Vora on 7/30/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *representativeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableViewRepresentatives;
@property NSArray *representatives;
@property User *currentRepresentative;
@property (weak, nonatomic) IBOutlet WKWebView *contactWebView;


@end

@implementation ContactViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupValues];

}

#pragma mark - Setup

- (void)setupTableView {
    self.tableViewRepresentatives.delegate = self;
    self.tableViewRepresentatives.dataSource = self;
    self.tableViewRepresentatives.hidden = YES;
    self.tableViewRepresentatives.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupValues {
    self.representatives = [User currentUser].followedRepresentatives;
    self.currentRepresentative = self.representatives[0];
    [self.currentRepresentative fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable rep, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error with fetching representative to show in dropdown menu: %@", error.localizedDescription);
        } else {
            [self.representativeButton setTitle:[self.currentRepresentative fullTitleRepresentative] forState:UIControlStateNormal];
            [self fetchContactForm];
        }
    }];
}

#pragma mark - Data Query

- (void)fetchContactForm {
    NSString *urlString = self.currentRepresentative.contact;
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [self.contactWebView loadRequest:request];
}


#pragma mark - Actions

- (IBAction)pressedRepresentative:(id)sender {
    self.tableViewRepresentatives.hidden = !(self.tableViewRepresentatives.hidden);
}

- (IBAction)pressedCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepresentativeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepresentativeCell"];
    User *representative = self.representatives[indexPath.row];
    if (cell == nil) {
        cell = [[RepresentativeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RepresentativeCell"];
    }
    cell.representative = representative;
    [cell updateValues];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.representatives.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    RepresentativeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.representativeButton setTitle:[cell.representative fullTitleRepresentative] forState:UIControlStateNormal];
    self.currentRepresentative = cell.representative;
    tableView.hidden = YES;
    [self fetchContactForm];
    [UIView animateWithDuration:3 animations:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

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

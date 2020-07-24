//
//  APIManager.m
//  Represent
//
//  Created by Ria Vora on 7/14/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "APIManager.h"

static NSString * const key = @"PQr31zdf3ibsr3mz9neLib2acbI3FhAn4SvN1cBx";
static NSString * const baseURLString = @"https://api.propublica.org/congress/v1/";


@implementation APIManager

#pragma mark - Init

- (id)init {
    self = [super init];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    return self;
}

#pragma mark - Bill Data

- (void)fetchRecentBills:(int)offset :(void(^)(NSArray *bills, NSError *error))completion {
    NSMutableURLRequest *request = [self createRequest:[NSString stringWithFormat:@"both/votes/recent.json?offset=%d", offset]];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error fetching recent Bills: %@", error.localizedDescription);
            completion(nil, error);
        }
        else {
            NSLog(@"Success fetching recent Bills!");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(dataDictionary[@"results"][@"votes"], nil);
        }
    }];
    [task resume];
}

#pragma mark - Representative Data

- (void)fetchSenators:(void(^)(NSArray *senators, NSError *error))completion {
    NSMutableURLRequest *request = [self createRequest: @"116/senate/members.json"];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error fetching senators: %@", error.localizedDescription);
            completion(nil, error);
        }
        else {
            NSLog(@"Success fetching senators!");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completion(dataDictionary[@"results"][0][@"members"], nil);
        }
    }];
    [task resume];
}

- (void)fetchHouseReps:(void(^)(NSArray *reps, NSError *error))completion {
    NSMutableURLRequest *request = [self createRequest: @"116/house/members.json"];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error fetching house reps: %@", error.localizedDescription);
            completion(nil, error);
        }
        else {
            NSLog(@"Success fetching house reps!");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completion(dataDictionary[@"results"][0][@"members"], nil);
        }
    }];
    [task resume];
}

- (void)fetchVotes: (NSString *)votesURL :(void(^)(NSArray *votes, NSError *error))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:votesURL]];
    [request setValue:@"PQr31zdf3ibsr3mz9neLib2acbI3FhAn4SvN1cBx" forHTTPHeaderField:@"X-API-KEY"];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error fetching votes: %@", error.localizedDescription);
            completion(nil, error);
        }
        else {
            NSLog(@"Success fetching votes!");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completion(dataDictionary[@"results"][@"votes"][@"vote"][@"positions"], nil);
        }
    }];
    [task resume];

}


#pragma mark - Helpers

- (NSMutableURLRequest *)createRequest :(NSString *)call {
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", baseURLString, call];
    NSURL *URL = [NSURL URLWithString:fullURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setValue:@"PQr31zdf3ibsr3mz9neLib2acbI3FhAn4SvN1cBx" forHTTPHeaderField:@"X-API-KEY"];
    return request;
}
@end

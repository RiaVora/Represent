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

- (id)init {
    self = [super init];

    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    return self;
}

- (void)fetchRecentBills:(void(^)(NSArray *bills, NSError *error))completion {
    NSMutableURLRequest *request = [self createRequest:@"116/both/bills/introduced.json"];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error fetching recent Bills: %@", error.localizedDescription);
            completion(nil, error);
        }
        else {
            NSLog(@"Success fetching recent Bills!");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completion(dataDictionary[@"results"], nil);
        }
    }];
    [task resume];
}

- (void)fetchLocalReps: (NSString *)state :(void(^)(NSArray *representatives, NSError *error))completion {
    NSMutableURLRequest *request = [self createRequest: [NSString stringWithFormat:@"members/senate/%@/current.json", state]];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error fetching local Representatives: %@", error.localizedDescription);
            completion(nil, error);
        }
        else {
            NSLog(@"Success fetching local Representatives!");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completion(dataDictionary[@"results"], nil);
        }
    }];
    [task resume];
}

- (void) fetchSenators:(void(^)(NSArray *senators, NSError *error))completion {
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

- (NSMutableURLRequest *)createRequest :(NSString *)call {
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", baseURLString, call];
    NSURL *URL = [NSURL URLWithString:fullURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setValue:@"PQr31zdf3ibsr3mz9neLib2acbI3FhAn4SvN1cBx" forHTTPHeaderField:@"X-API-KEY"];
    return request;
}
@end

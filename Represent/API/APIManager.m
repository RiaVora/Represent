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
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", baseURLString, @"116/both/bills/introduced.json"];
    NSURL *URL = [NSURL URLWithString:fullURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setValue:@"PQr31zdf3ibsr3mz9neLib2acbI3FhAn4SvN1cBx" forHTTPHeaderField:@"X-API-KEY"];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
        else {
            NSLog(@"Success!");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completion(dataDictionary[@"results"], nil);
        }
    }];
    [task resume];
}
@end

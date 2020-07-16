//
//  User.h
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <Parse/Parse.h>
#import "Utils.h"
#import "APIManager.h"

NS_ASSUME_NONNULL_BEGIN
@class Utils;
@interface User : PFUser<PFSubclassing>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *profileDescription;
@property (nonatomic, strong) NSString *party;
@property (nonatomic, strong) NSMutableArray *followedRepresentatives;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) PFFileObject *profilePhoto;
@property (nonatomic) BOOL isRepresentative;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *shortPosition;
@property (nonatomic, strong) NSString *lastName;


+(User*)user;
- (void)signUpUser: (NSString *)firstName email:(NSString *)email state:(NSString *)state username:(NSString *)username password:(NSString *)password isRepresentative:(BOOL)isRepresentative withCompletion: (PFBooleanResultBlock  _Nullable)completion;
- (void)getRepresentatives;
+ (void) signUpRepresentative: (NSDictionary *)representative;

@end

NS_ASSUME_NONNULL_END

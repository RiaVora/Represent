//
//  User.h
//  Represent
//
//  Created by Ria Vora on 7/13/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser<PFSubclassing>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *profileDescription;
@property (nonatomic, strong) NSString *party;
@property (nonatomic, strong) NSMutableArray *followedRepresentatives;
@property (nonatomic, strong) NSNumber *zipcode;
@property (nonatomic, strong) PFFileObject *profilePhoto;
@property (nonatomic) BOOL *isRepresentative;
@property (nonatomic, strong) NSString *position;

+(User*)user;
- (void)signUpUser: (NSString *)firstName email:(NSString *)email zipcode:(NSString *)zipcode username:(NSString *)username password:(NSString *)password withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

@end

NS_ASSUME_NONNULL_END

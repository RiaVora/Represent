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
#import "Question.h"

/*The User class is a PFUser class that is used to represent one User object (either a User or Representative) from the Parse database. The User object contains additional attributes past the basic Parse User class such as isRepresentative, firstName, party, etc. and is referenced throughout the application. For functionality, the User clas has methods where votes are saved on the votedQuestions array and Users (representatives) are saved on the followedRepresentatives array.*/

NS_ASSUME_NONNULL_BEGIN
@class Utils;
@class Question;
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
@property (nonatomic, strong) NSMutableArray *votedQuestions;


+(User*)user;
- (void)signUpUser: (NSString *)firstName email:(NSString *)email state:(NSString *)state username:(NSString *)username password:(NSString *)password isRepresentative:(BOOL)isRepresentative withCompletion: (PFBooleanResultBlock  _Nullable)completion;
- (void)getRepresentatives;
+ (void) signUpRepresentative: (NSDictionary *)representative;
- (NSString *)fullTitleRepresentative;
- (BOOL)hasVoted:(Question *)question;
- (BOOL)voteOnQuestion:(Question *)question;

@end

NS_ASSUME_NONNULL_END

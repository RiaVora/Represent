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

/*The first name of the user.*/
@property (nonatomic, strong) NSString *firstName;

/*The written profile description of the user, null if not created.*/
@property (nonatomic, strong) NSString *profileDescription;

/*The party of the user, either D, R, I, ID (if representative) or Democrat, Republican, Independent, or Non-Affiliated (if non-representative).*/
@property (nonatomic, strong) NSString *party;

/*An array of the representatives the user has chosen to follow, automatically assigned by zipcode during signup.*/
@property (nonatomic, strong) NSMutableArray *followedRepresentatives;

/*The state the user lives in, entered at sign-up (hoping to later integrate zipcode).*/
@property (nonatomic, strong) NSString *state;

/*The profile photo of the user, can be assigned through Facebook or Profile screen, null if not assigned.*/
@property (nonatomic, strong) PFFileObject *profilePhoto;

/*Whether the user is a representative.*/
@property (nonatomic) BOOL isRepresentative;

/*If the user is a representative, then their position and rank (i.e. Senator, 2nd class). If the user is a non-representative, then null.*/
@property (nonatomic, strong) NSString *position;

/*If the user is a representative, then their link to a contact form. If the user is a non-representative, then null.*/
@property (nonatomic, strong) NSString *contact;

/*If the user is a representative, then their short position (i.e. Sen., Rep.). If the user is a non-representative, then null.*/
@property (nonatomic, strong) NSString *shortPosition;

/*If the user is a representative, then their last name. If the user is a non-representative, then null.*/
@property (nonatomic, strong) NSString *lastName;

/*An array of pointers to Questions that the user has voted on.*/
@property (nonatomic, strong) NSMutableArray *votedQuestions;

/*An NSDate object representing the last time the user voted (used to reset vote counts).*/
@property (nonatomic, strong) NSDate *lastVoted;

/*The current amount of votes the user can use. Resets every new Calendar day to 5 votes, and cannot exceed 5.*/
@property (nonatomic, strong) NSNumber *availableVoteCount;

/*If the user is a representative, then their unique representative ID assigned by Congress. If the user is a non-representative, then null.*/
@property (nonatomic, strong) NSString *representativeID;




+(User*)user;
- (void)signUpUser: (NSString *)firstName email:(NSString *)email state:(NSString *)state username:(NSString *)username password:(NSString *)password isRepresentative:(BOOL)isRepresentative withCompletion: (PFBooleanResultBlock  _Nullable)completion;
- (void)findRepresentatives;
+ (void) signUpRepresentative: (NSDictionary *)representative;
- (NSString *)fullTitleRepresentative;
- (BOOL)hasVoted:(Question *)question;
- (BOOL)voteOnQuestion:(Question *)question;
- (BOOL)votesLeft;
- (void)updateAvailableVotes;

@end

NS_ASSUME_NONNULL_END

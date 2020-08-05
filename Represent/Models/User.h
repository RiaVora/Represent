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

/*PROPERTIES*/

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

/*The number of questions remaining for the representative to answer. If the user is a non-representative, then null.*/
@property (nonatomic, strong) NSNumber *questionsLeftCount;

/*If the user is a representative, then their unique representative ID assigned by Congress. If the user is a non-representative, then null.*/
@property (nonatomic, strong) NSString *representativeID;

/*METHODS*/

/*When creating a new User, returns the correct User sub-classed of PFUser.
 
 @return a new User
 */
+(User*)user;

/*Creates a new User object with the given parameters.
 
 @param firstName is the first name of the new user
 @param email is the email of the new user
 @param state is the state of the new user
 @param username is the username of the new user
 @param password is the password of the new user
 @param isRepresentative is YES if the new user is a representative, and NO if the new user is not a representative
 @completion gives whether the user was signed up successfully; error otherwise
 */
- (void)signUpUser: (NSString *)firstName email:(NSString *)email state:(NSString *)state username:(NSString *)username password:(NSString *)password isRepresentative:(BOOL)isRepresentative withCompletion: (PFBooleanResultBlock  _Nullable)completion;

/*Creates a new Representative User with the given dictionary.
 
 @param representative is a dictionary containing a representative to be turned into a user
 */
+ (void)signUpRepresentative: (NSDictionary *)representative;

/*Creates the full title of a representative User with their short position, first name, and last name.
 
 @return a string combining the short position, first name, and last name of the representative; nil if the user is not a representative
 */
- (NSString *)fullTitleRepresentative;

/*Returns whether the User has voted on a particular Question.
 
 @param question is the question to be checked
 @return YES if the question has been voted on by the user, NO otherwise;
 */
- (BOOL)hasVoted:(Question *)question;

/*Returns whether the User is following the given representative
 
 @param newRep is a new representative to be added to the user's followed representatives
 @return YES if the user has this representative already; NO otherwise
 */
- (BOOL)hasRep:(User *)newRep;

/*If possible, has the User vote on the Question by changing vote count and voted Questions array.
 
 @param question is the question to be voted on
 @return YES if the question was voted on successfully, and NO if the question was unvoted
 */
- (BOOL)voteOnQuestion:(Question *)question;

/*Returns whether the User has votes remaining in their available vote count.
 
 @return YES if the User has votes remaining; NO otherwise
 */
- (BOOL)votesLeft;

/*Checks when the user has last votes and updates their available vote count accordingly.*/
- (void)updateAvailableVotes;

/*Updates the user's representatives to reflect their new state.
 
 @param state is the new state to change the user's representatives to.
 */
- (void)changeState: (NSString *)state;

@end

NS_ASSUME_NONNULL_END

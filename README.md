Original App Design Project - README Template
===
# Represent

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Represent connects you to your Legislators and Representatives, giving you the ability to ask your pressing questions, follow their votes on the Senate, House of Representatives, and local bills, and connect directly with them to share your views and hold them accountable.
Government and Politics isn't for a specific group of people; it affects every citizen and individual living under that government. Represent is here to make social justice accessible, easy-to-be-a-part-of, and unbiased. The public deserves to be involved and informed.

### App Evaluation
- **Category:** Education/Social Networking/News
- **Mobile:** Through a mobile interface, Represent is easily accessible for voting on questions throughout the day, sending emails or chats to your Representatives, and setting up a profile. Real-time data and push notifications keep you on-top of the latest news and the bills that directly affect you. 
- **Story:** Individuals will use Represent to finally feel like they have an active say in their government and their Representatives' action. Politics & Government has become too complicated for the regular voter to follow. Users will want to use Represent for a simple understanding the way bills and measures passed affects them, and a way to follow their Representatives' actions, bringing their voice back into the playing field.
- **Market:** Once completed, Represent appeals to anyone who isn't heavily invested in government or politics. It gives regular voters (with jobs in virtually every industry) the information and resources to keep up with their Representatives and government. Although only users over 18 have the ability to choose their Representatives, Represent also appeals to the youth who are focused and interested in the impact that government has. 
- **Habit:** Users will be motivated to come back to the app due to give components: (1) Voting on 3 new questions on a daily basis (2) Asking their own question (3) Seeing the top-voted question and their Representatives' response (4) Following their Representatives' posts and (5) Commenting and following their Representatives' positions on bills/measures. Represent's questions will be refreshed every [TBD].
- **Scope:** The basic functionality of this app, which will hopefully be completed by the end of this project, is (1) a view to vote and ask questions to a specific representative (2) a profile with log-in and log-out capabilities (each profile will also be linked to relevant Representatives through location) (3) a view to see your relevant Representatives vote on a bill and (4) a way to contact your Representatives through email or chat. Additional optional ideas include hashtags for every question alluding the topic (such as #politics, #george-floyd), an short explanation of each bill, the ability to view all Representatives' votes on the bills, the ability to comment on bills, the ability to share a specific Representatives' response, etc.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
* Connect to Parse
* Connect to ProPublica API
* The user can log in to an account with their username and password
* The user can create an account with their first name, email, username, password, and zipcode
* The user's profile is linked to relevant Representatives (they can choose to share their location or choose Representatives)
* The TableView is setup to show basic Questions
* Each Question has a user, a vote button, a timestamp, a vote count, and the question
* The user can vote on a question
* The user can swipe down on the screen to refresh
* The question the user votes for, if the vote count changes to be higher than the above question, moves up on the screen without the user refreshing
* The user can toggle between Representatives and their questions
* Prevent the user from voting more than three times a day with a pop-up message
* The user can submit a question
* The question the user posts shows up on the screen without the user refreshing
* The TableView is setup to show basic Bills
* Each bill has the name of the bill, the scope (Senate, House of Reps, etc.), and whether it passed
* Each bill displays the votes of relevant/top representatives
* The user can swipe down on the screen to refresh
* The user can view a basic version of their profile on the tab (the segue is set up)
* The user can view a detailed version of their profile with the parameters description, party, etc.
* The user can edit their description
* The user can click on profile pictures in the Questions Screen to view a user's profile (without the edit option)
* The user can swipe down on the screen to refresh their or others' profile
* At the top of their profile, the user can choose to directly contact their Representatives
* The user can choose which representative to contact
* The user can see a detailed view of inputting their last name, email, etc.
* The user can send a message

**Optional Nice-to-have Stories**

* Top-notch UI with animations
* The user can follow Representatives that are not their relevant Representatives, and it adds them to their toggle menu in View - Questions and allows them to contact them
* The user's profile dispalys interests
* The user can edit their party and interests
* The user can view a detailed version of the Bills in a DetailsViewController
* The detail view of the bill has arguments for each side
* The user can view their posted questions through a toggle menu on their profile
* The user cannot vote on their own question
* The user is limited by characters on their question
* The user cannot post hate speech on their question
* The user can comment on Bills
* The user can comment on Questions
* The user can react to comments and respond to comments
* The user's latest votes are displayed publicly on their profile
* The user's comments are displayed publicly on their profile
* The user can change their profile to private or public
* The user can have followers who can see their votes (if they are on private)
* The user can tag the question they ask with hashtags of their choice. The most popular of these hashtags show up beneath the question
* The user can click on the # of votes label to see who publicly voted and the number of private votes
* When the user uses "@" they can tag a representative
* When the user uses "+" they can tag a bill
* The bills and underlying database has up-to-date information
* The bill can be clicked on to view a detailed view
* The user can choose to directly send a chat to a representative instead of email

### 2. Screen Archetypes
* Networking
    * Connect to Parse
    * Connect to ProPublica API
* Login Screen
    * The user can log in to an account with their username and password
* Registration Screen
    * The user can create an account with their first name, email, username, password, and zipcode
    * The user's profile is linked to relevant Representatives (they can choose to share their location or choose Representatives)
* Questions Screen
    * The TableView is setup to show basic Questions
    * Each Question has a user, a vote button, a timestamp, a vote count, and the question
    * The user can vote on a question
    * The user can swipe down on the screen to refresh
    * The question the user votes for, if the vote count changes to be higher than the above question, moves up on the screen without the user refreshing
    * The user can toggle between Representatives and their questions
    * Prevent the user from voting more than three times a day with a pop-up message
* Post Question Screen
    * The user can submit a question
    * The question the user posts shows up on the screen without the user refreshing
* Bills Screen
    * The TableView is setup to show basic Bills
    * Each bill has the name of the bill, the scope (Senate, House of Reps, etc.), and whether it passed
    * Each bill displays the votes of relevant/top representatives
    * The user can swipe down on the screen to refresh
* Profile Screen
    * The user can view a basic version of their profile on the tab (the segue is set up)
    * The user can view a detailed version of their profile with the parameters description, party, etc.
    * The user can edit their description
    * The user can click on profile pictures in the Questions Screen to view a user's profile (without the edit option)
    * The user can swipe down on the screen to refresh their or others' profile
* Contact Screen
    * At the top of their profile, the user can choose to directly contact their Representatives
    * The user can choose which representative to contact
    * The user can see a detailed view of inputting their last name, email, etc.
    * The user can send the message

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Screen [Tabs to Questions, Bills, and Profile]
* Post & Cancel a Question
* Contact a Representative

**Flow Navigation** (Screen to Screen)

* Log-In Screen
   * Questions
* Registration Screen
   * Questions
* Profile
   * Questions
   * Bills
* Questions
   * Profile
   * Bills
* Post Questions
   * Questions
* Bills
   * Profile
   * Questions
* Contact
   * Profile

## Wireframes
[Interactive Prototype](https://xd.adobe.com/view/ce57c1e4-24fd-4f57-9624-d219af34f151-9b04/)
(Buttons that are clickable will highlight after a few seconds!)

## Schema 

### Models


**Question**
| **Property**   | **Type**        | **Description**                              |
|----------------|-----------------|----------------------------------------------|
| objectID       | String          | [default] Unique ID for the user's question  |
| createdAt      | DateTime        | [default] when the question was posted       |
| updatedAt      | DateTime        | [default] when the question was last updated |
| author         | Pointer to User | author of the question                       |
| text           | String          | question that user has posted                |
| voteCount      | Number          | number of votes the question has gotten      |
| representative | Pointer to User | representative the question is directed to   |


**User**
| **Property**            | **Type**    | **Description**                                            |
|-------------------------|-------------|------------------------------------------------------------|
| objectID                | String      | [default] Unique ID for the user                           |
| createdAt               | DateTime    | [default] when the user was created.                       |
| updatedAt               | DateTime    | [default] when the user was last updated                   |
| firstName               | String      | first name of user                                         |
| username                | String      | username of user                                           |
| password                | String      | password of user                                           |
| email                   | String      | email of user                                              |
| description             | String      | user's personal description on their profile               |
| party                   | String      | user's political party                                     |
| followedRepresentatives | Array<User> | array of representatives that the user is following        |
| zipcode                 | Number      | zipcode of user                                            |
| profilePhoto            | File        | profile photo of user                                      |
| isRepresentative        | Boolean     | whether the user is a representative                       |
| position                | String      | if the user is a representative, then role, i.e. "Senator" |


**Bill**
| **Property** | **Type**                 | **Description**                                                              |
|--------------|--------------------------|------------------------------------------------------------------------------|
| objectID     | String                   | [default] Unique ID for the bill                                             |
| createdAt    | DateTime                 | [default] when the bill was posted                                           |
| updatedAt    | DateTime                 | [default] when the bill was last updated                                     |
| title        | String                   | official title of bill                                                       |
| description  | String                   | short description of bill's intentions                                       |
| passed       | String                   | if the bill has "Passed", "Failed", or is "Still in Contention"              |
| position     | String                   | the type of people voting on this bill, i.e. "Senator"                       |
| votes        | Dictionary<User, String> | a user (representative) linked to a string of "For", "Against", or "Abstain" |
| votesFor     | Number                   | number of votes "For" the bill                                               |
| votesAgainst | Number                   | number of votes "Against" the bill                                           |


### Networking


**Login Screen**
| **Action** | **Object** | **Description**                              |
|------------|------------|----------------------------------------------|
| GET        | User       | checks if user exists with given credentials |


Signup Screen
| **Action** | **Object** | **Description**                                       |
|------------|------------|-------------------------------------------------------|
| POST       | User       | creates a new user object with the signup information |


**Questions Screen**
| **Action** | **Object** | **Description**                                      |
|------------|------------|------------------------------------------------------|
| GET        | Question   | all questions addressed to a specific representative |


**Compose Question Screen**
| **Action** | **Object** | **Description**                         |
|------------|------------|-----------------------------------------|
| POST       | Question   | question for a representative is posted |


**Bills Screen**
| **Action** | **Object** | **Description**                                   |
|------------|------------|---------------------------------------------------|
| GET        | Bill       | all bills, perhaps under specific search criteria |


**Profile Screen**
| **Action** | **Object**                     | **Description**                              |
|------------|--------------------------------|----------------------------------------------|
| GET        | User                           | the user associated with the current account |
| POST       | User (profilePhoto)            | changes the profile photo for the user       |
| POST       | User (description)             | changes the description for the user         |
| POST       | User (party)                   | changes the party of the user                |
| POST       | User (followedRepresentatives) | changes the representatives the user follows |
| POST       | User (zipcode)                 | changes the zipcode of the user              |
| POST       | User (username)                | changes the username of the user             |
| POST       | User (firstName)               | changes the first name of the user           |


### External API Calls
API for Bills and Votes: [ProPublica Congress API](https://projects.propublica.org/api-docs/congress-api/)

### External Resources

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [DateTools](https://cocoapods.org/pods/DateTool) - formatting for Date and Time
- [Parse](https://cocoapods.org/pods/Parse) - Parse Objects and communication


# Sprint Planning 3

### Project Summary:
An app that uses an unique queue matching system to allow users to have 1 on 1 video chats with other people. A way to create social bonds or networking in a community, specifically in Universities. 

### Trello Link:
https://trello.com/b/Ctr0GQnf/ecs-189e-project

### What was done with commit links and descriptions:

**Eden Avivi** - 

* Started implementing the Firebase Auth API calls for login and sign up screens, added a custom pop up for resetting the password in the login view which sends a custom email to the user's email through Firebase and has the steps to reset there.

* Finished up the login and sign up view controllers by adding tap recognizers and text field return functions.

* Started working on the lobby view controller by looking into animation in general and determined that the animation itself should be in xcode, after making an animation in After Effects. After Effects animation *maybe* will used for later screens/other aspects.

Commits: (I had some merging problems with master, so some of my commits are on Wai Hei Ngan's account since he helped with the merge)

https://github.com/ECS189E/project-w21-big-bang-theory/commit/470120918ff4aac6e496c060d317406a20090ae6#diff-f0bd699b419718c4f95799f8863e0376a21d0daef476803700ec894ba624053a

https://github.com/ECS189E/project-w21-big-bang-theory/commit/1d249950a2bc0867a5f030ab5ef1b263adb6f804 (On my branch for now)

First animation try with emitter: https://github.com/ECS189E/project-w21-big-bang-theory/commit/06eb1f66e982b3ca981c1515abe3f4e081e8e514 (On my branch for now)

Could not find a limiter for the number of bubbles in the emitter and could not have the bubbles stop at the edges of the screen, so went on to make an array of individual bubbles and animated each once randomly. Added functionality to have the size of the array be the number of users in the lobby (current temp array size is 10).

https://github.com/ECS189E/project-w21-big-bang-theory/commit/b352965bf94897b0a2b6894e3711db9e9d1f6787 (On my branch for now)

https://github.com/ECS189E/project-w21-big-bang-theory/commit/8638dcc32670797a98e428abfde4dbff29241228 (On my branch for now)

https://github.com/ECS189E/project-w21-big-bang-theory/commit/fbf77324afa307c2137bb6fdbd9a621dab9e8031 (On my branch for now)

**Gharam Alsaedi** - 
- Worked on Matching Screen
  - Created the UI for the Screen
  - Create the popup view that will hold the match's information. I created the functionalities of showing and hiding the view.
  - Added the swiping gestures (right and left), and the image tap gesture
  - Created an action for the back button that takes the user to profile screen.
  - Created RounderImageView class that makes an image round if inherited
- Added Font target
- Researched Google Analytics to be used for finding the current user's in the lobby screen

https://github.com/ECS189E/project-w21-big-bang-theory/commit/422b3759cd0ea5181dda001f2c43d49543cf63b6 (On my branch for now)
https://github.com/ECS189E/project-w21-big-bang-theory/commit/56134b90c4605270fcfe5d7cfe8c73477496ef94 (On my branch for now)
https://github.com/ECS189E/project-w21-big-bang-theory/commit/195649f9b29860ef52519ece19be62d69e63c5a0 (On my branch for now)

**Ma Eint Poe** -


**Wai Hei Ngan** -
- Combined Video chatting features and firebase API and pushed to master
  - https://github.com/ECS189E/project-w21-big-bang-theory/commit/470120918ff4aac6e496c060d317406a20090ae6
- Worked on adding more Video Chatting Features
  - Added all the icons nesscary
  - Implement some of the icons features
- Added a timer model for the Video call

### Plan to do:

**Eden Avivi** - 
Continue working on the lobby view controller by researching how to know how many users are in a specific view controller, have the matching process happen in the lobby view and have the lobby view controller stay until a match is found, in which case the match view controller will appear next.

**Gharam Alsaedi** - 
Will use Firebase Analytics' to get currently active users and connect their info to the matching UI. I will also implement the matching algorithm to check if the other user accepted or rejected the call and moved to the relative screens. Find a way to keep track of rejected matches such that they dont show up again in current setting.

**Ma Eint Poe** -


**Wai Hei Ngan** -
Generate token for each user. Create a new room for user to join when they press accept.

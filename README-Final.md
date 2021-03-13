# PopMatch Documentation
## Team [The Big Bang Theory]! 
## Group Members:
<img src="https://user-images.githubusercontent.com/52867931/110847792-33a83680-8262-11eb-88da-df669f99d09b.png" width="40"> Eden Avivi, eavivi4 (sometimes just Eden) <br />
<img src="https://user-images.githubusercontent.com/52867931/110847792-33a83680-8262-11eb-88da-df669f99d09b.png" width="40"> Gharam Alsaedi, gharams19 <br />
<img src="https://user-images.githubusercontent.com/52867931/110847792-33a83680-8262-11eb-88da-df669f99d09b.png" width="40"> Wai Hei Ngan, rayngan999 <br />
<img src="https://user-images.githubusercontent.com/52867931/110847792-33a83680-8262-11eb-88da-df669f99d09b.png" width="40">  Ma Eint Poe, maeintpoe

## Description
<img src="https://user-images.githubusercontent.com/52867931/110847792-33a83680-8262-11eb-88da-df669f99d09b.png" width="40"> PopMatch <img src="https://user-images.githubusercontent.com/52867931/110847792-33a83680-8262-11eb-88da-df669f99d09b.png" width="40"> OR <img src="https://user-images.githubusercontent.com/52867931/110848697-3ce5d300-8263-11eb-90bb-ad46beca2aee.png" width="100"> OR PopMatch is a video chatting app that allows users to have 1 on 1 meetings with new people and like minded thinkers. It's a way to create social bonds and network for university students. Our app aims to mitigate the lack of social interaction as a result of the pandemic and having everything go virtual. With PopMatch, users are able to create a profile with a short personalized interest form. Based on the availablity of current users online, they will get match with someone they have the most in common with. Once they both accept the match, they can have an extendable 5 minute video chat filled with fun ice-breaker questions to keep the conversation going. If they want to extend this further, they can also exchange social medias with a press of a button that leads right them to the other's social media profile. PopMatch combines the well-liked features of being able to meet new people like Omelge while giving them the choice in who they actually talk to similarly to Tinder, but with a touch of personalized mutual interest matching. (Might need to reword this)

## App Flow: 
<img src="https://user-images.githubusercontent.com/52867931/110840687-e1fbae00-8259-11eb-85f6-440a69328f29.png" width="160"> <img src="https://user-images.githubusercontent.com/52867931/110840692-e2944480-8259-11eb-925c-eeae40b31ba6.png" width="160"> <img src="https://user-images.githubusercontent.com/52867931/110840683-e0ca8100-8259-11eb-8381-8fa2d3fea11a.png" width="160"> <img src="https://user-images.githubusercontent.com/52867931/110840690-e1fbae00-8259-11eb-8571-90b34eb878a5.png" width="160"> <img src="https://user-images.githubusercontent.com/52867931/110840685-e1631780-8259-11eb-9c1e-0f0ed8ba0478.png" width="160"> 

<img src="https://user-images.githubusercontent.com/52867931/110841422-b5946180-825a-11eb-8180-85db360b120c.png" width="160"> <img src="https://user-images.githubusercontent.com/52867931/110841425-b62cf800-825a-11eb-987d-c128861826b1.png" width="160"> <img src="https://user-images.githubusercontent.com/52867931/110841426-b62cf800-825a-11eb-884e-51b2d01b7b19.png" width="160"> <img src="https://user-images.githubusercontent.com/52867931/110841438-b88f5200-825a-11eb-8ac1-0538ecc0dce5.png" width="160">

*Note to self: Update the screenshots with the new UI updates later

## Roles & Contribution:
* Eden Avivi
* Gharam Alsaedi
  * Designed the UI, specifically designed the pages including the buttons' icons and logo. As well as the overall flow of the app.
  * Set up presence system (Online/Offline) using firebase's Realtime database.
  * Created matching algorithm which finds the most ideal match by filtering out users that are either unavailable or offline and then match the current user with the person they have most in common with. Also worked on the accept/reject a match algorithm.
  * Worked on sending and receiving social media links in the video chat.

* Wai Hei Ngan
* Ma Eint Poe

## ViewController Detailed Descriptions ?
### Login VC & Sign Up VC
Here, returning users can login again if they have previously logged out. This will lead them to the profile view controller upon successful login. For the first time users, they can start by signing up and starting their PopMatch profile. This will lead them to the friend view controller.

### Friend VC 
For the first time users, here is where they will be first navigated to so that they can fill out a questionnaire regarding their basic demographic and some interests which will used in our algorithm. However, if you are a returning user, you can always revisit here from the profile view controller and make changes your selections.

### Profile VC
This is like the home page where users are redirected upon login and is the source of navigate to the others such as joining the lobby for a match, signing out, or the personal interest questionnaire. Here, users can make changes regarding their account info and profile picture.

### Lobby VC
Here is where the users will be waiting to get a match with other currently online users. They'll be shown a loading bubble animation while our matching algorithm runs in the background. Once a match has been found, a larger bubble will be displayed on the screen.

### Matching and Pre-Meeting VC
With a match found, this is where the users will be shown the profile of their match along the options to accept or reject the call and a countdown timer for them to make their choice. They can also press on bubble with the matched user's profile picture to view a more detailed description with their selections from the questionnaire. Upon an acceptance, the user will be directed to the loading pre-meeting view controller to wait while the matched user makes their choice to accept or not.

### Meeting VC
Here lies the core of our app - the video chatting. After both the matched users accept, this is where they can begin to chat and (hopefully) be the start of a new friendship :) They can discuss some fun and debatable ice-breaker questions to get a conversation going, and even extend the call time to keep chatting. This is also where can take this conversation a step furthur and share social medias with each other now that they've made a new friend.

## Progress 
Trello Board: https://trello.com/b/Ctr0GQnf/ecs-189e-project

## Come join PopMatch and pop some bubbles!

<img src="https://user-images.githubusercontent.com/52867931/110848697-3ce5d300-8263-11eb-90bb-ad46beca2aee.png" width="200"> 

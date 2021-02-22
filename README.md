# Milestone 1 Documentation

### Pop Match:
A video chatting app that allows users to have 1 on 1 meetings with new people and like minded thinkers. A ways to create soical bonds or networks in a community, specifically in Universites.

### Designs for all screens to be used
[Figma Wireframe](https://www.figma.com/file/C1nZuKT19fLt7fyb8CQKS2/The-Big-Bang-Theory?node-id=0%3A1)

### List of third party libraries and server support
- Firebase
- Twilio

Since we are using Firebase for our data storage and authentication of emails and passwords, and Twilio for the video aspect, we have not found an Api component needed to be implmeneted for now.

### List of all view controllers
* Splash Screen
* Login 
* Sign up 
* Profile 
* Setting
* Professional Questionnaire 
* Friend Questionnaire 
* Lobby (loading screen)
* Match 
* Video

Navigation between the VC: [Figma Wireframe](https://www.figma.com/proto/C1nZuKT19fLt7fyb8CQKS2/%5BThe-Big-Bang-Theory%5D!?node-id=17%3A25&scaling=scale-down)

Protocols for UserDelegate: (will keep updating)

`userDataChanged()` : To handle the changes to the user data such as name, social media, etc.

`displayMatch()` : To handle the matching between different users

`callStatusChange()` : To handle the the starting, extending, and ending of video calls


Delegates: (will keep updating)
* UITextFieldDelegate 
* UITableViewDelegate
* UserDelegate 



### List of models

- Timer Model
- Video Model
- User Model

### List of week long tasks

https://github.com/ECS189E/project-w21-big-bang-theory/blob/master/Week_Long_Tasks.md

### Trello board link
https://trello.com/b/Ctr0GQnf/ecs-189e-project

### Group member names, usernames and photos:
Eden Avivi, eavivi4 (sometimes just Eden)
<br/>
<img src="https://github.com/ECS189E/project-w21-big-bang-theory/blob/Eden/Images/EdenPic.jpg"  width="300"/>

Gharam Alsaedi, gharams19
<br/>
<img src="https://github.com/ECS189E/project-w21-big-bang-theory/blob/Eden/Images/GharamPic.jpg"  width="300"/>

Wai Hei Ngan, rayngan999 
<br/>
<img src="https://github.com/ECS189E/project-w21-big-bang-theory/blob/Eden/Images/RayPic.jpeg"  width="300"/>

Ma Eint Poe, maeintpoe
<br/>
<img src="https://github.com/ECS189E/project-w21-big-bang-theory/blob/Eden/Images/MaEintPoe.png"  width="300"/>

### Testing Plan
<https://github.com/ECS189E/project-w21-big-bang-theory/blob/Eden/Testing_Plan.md>

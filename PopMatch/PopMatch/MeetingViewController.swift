//
//  MeetingViewController.swift
//  PopMatch
//
//  Created by Ray Ngan on 2/21/21.
//


import UIKit
import TwilioVideo
import Firebase
import FirebaseStorage
import FirebaseUI


protocol TimerUpdates: class {
    func stopTimer()
}


class MeetingViewController: UIViewController {
    

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var myView: VideoView!
    @IBOutlet weak var addTimerButton: UIButton!
    @IBOutlet weak var micImage: UIButton!
    @IBOutlet weak var vidImage: UIButton!
    @IBOutlet weak var endImage: UIButton!
    
    weak var delegate: TimerUpdates?
    var remoteView: VideoView!
    var room: Room?
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    var vidTimer: Timer?
    var roomName: String = ""
    var accessToken : String = ""
    var matchId = ""
   
    @IBOutlet weak var sendMediaText: UILabel!
    @IBOutlet weak var twitter: UIButton!
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var snapchat: UIButton!
    @IBOutlet weak var ig: UIButton!
    @IBOutlet weak var linkedin: UIButton!
    @IBOutlet weak var urlView: UIView!
    
    
    var db = Firestore.firestore()
    var storage = Storage.storage()
    
    var twitterLink: String = ""
    var facebookLink: String = ""
    var snapchatLink: String = ""
    var instagramLink: String = ""
    var linkedinLink: String = ""
    var checkUpdates: Timer?
    var links: [String] = []
    var y = 10
    var sentSocialsCount = 0
    var checkSentSocialsTimer: Timer?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareLocalMedia()
        self.connect()
        self.messageLabel.adjustsFontSizeToFitWidth = true;
        self.messageLabel.minimumScaleFactor = 0.75;
        self.links = [twitterLink, facebookLink, snapchatLink, instagramLink, snapchatLink]
        let userData = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        let userSocialData = userData.collection("socials").document("links")
        userSocialData.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    if let twitter = document.get("twitter") {
                        self.twitterLink = twitter as? String ?? ""
                    }
                    if let facebook = document.get("facebook") {
                        self.facebookLink = facebook as? String ?? ""
                    }
                    if let snapchat = document.get("snapchat") {
                        self.snapchatLink = snapchat as? String ?? ""
                    }
                    if let instagram = document.get("instagram") {
                        self.instagramLink = instagram as? String ?? ""
                    }
                    if let linkedin = document.get("linkedin") {
                        self.linkedinLink = linkedin as? String ?? ""
                    }
                } else {
                    print("Social Media link doc doesn't exists, user hasn't inputted any")
                }
            } else {
                print("Error in getting social document, error: \(String(describing: error))")
            }
        }
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.hideInfo), userInfo: nil, repeats: false)
       
        
        checkUpdates = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        
        checkSentSocialsTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.checkForSocials), userInfo: nil, repeats: true)
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        return self.room != nil
    }
    
    @objc func hideInfo(){
        messageLabel.isHidden = true
    }
    var flip = 0;
    @IBAction func tapGesture(_ sender: Any) {
        twitter.isHidden = flip == 0 ? true:false
        facebook.isHidden = flip == 0 ? true:false
        snapchat.isHidden = flip == 0 ? true:false
        ig.isHidden = flip == 0 ? true:false
        linkedin.isHidden = flip == 0 ? true:false
        sendMediaText.isHidden = flip == 0 ? true:false
        addTimerButton.isHidden = flip == 0 ? true:false
        vidImage.isHidden = flip == 0 ? true:false
        micImage.isHidden = flip == 0 ? true:false
        endImage.isHidden = flip == 0 ? true:false
        urlView.isHidden = flip == 0 ? true:false
        flip = flip == 0 ? 1 : 0
    }
    var questions: [String] = ["What goes in first? Milk or Cereal", "You are stranded on an island. What are 3 things you’re bringing?", "How do you pronounce gif?", "Favorite TV show?", "Never have I ever", "Two truths and a lie", "One thing I’ll never do again", "Most embarrassing thing that happened to you", "This year, I really want to", "If you could have any superpower, what would you want, and why?", "Worst professor experience", "Why did you choose your major", "What’s your ideal life"]
    
    var questionsNum  = 12
    
    @IBAction func generateQuestions(_ sender: Any) {
        let randInt = Int.random(in: 0..<questionsNum)
        self.db.collection("Rooms").document(roomName).setData(["Icebreaker":questions[randInt]], merge: true)
        questions.remove(at: randInt)
        questionsNum -= 1
    }
    
    
    
    @IBAction func sendTwitter(_ sender: Any) {
        if(twitterLink == ""){
            return
        }
        let uid = Auth.auth().currentUser?.uid ?? ""
        db.collection("Rooms").document(roomName).getDocument() {(document, error ) in
            if error == nil {
                if let document = document, document.exists {
                    var socials = document.get(uid) as? [String] ?? []
                    
                    if socials.contains(self.twitterLink) == false {
                        
                    socials.append(self.twitterLink)
                    self.db.collection("Rooms").document(self.roomName).setData([uid: socials], merge: true)
                    let attributedString = NSMutableAttributedString(string: "Follow me on Twitter")
                    let url = URL(string: self.twitterLink)
                    
                    let range = NSMakeRange(0, attributedString.length)
                    attributedString.setAttributes([.link: url], range: range)
             
                    let twitterTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))

                    attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16.0), range: range)

                    let linkAttributes: [NSAttributedString.Key: Any] = [
                        NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 0.42, green: 0.62, blue: 0.79, alpha: 1.0)]
                    twitterTextView.linkTextAttributes = linkAttributes
                    twitterTextView.attributedText = attributedString
                    twitterTextView.center = CGPoint(x: 160, y: self.y)
                    self.y += 25
                    twitterTextView.textAlignment = .center
                    twitterTextView.backgroundColor = UIColor.clear

                    twitterTextView.attributedText = attributedString
                    self.urlView.addSubview(twitterTextView)
                    self.urlView.isUserInteractionEnabled = true
                    twitterTextView.isEditable = false
                    }
                }
            }
            
        }
       
    }
    @IBAction func sendFacebook(_ sender: Any) {
        if(facebookLink == ""){
            return
        }
        let uid = Auth.auth().currentUser?.uid ?? ""
        db.collection("Rooms").document(roomName).getDocument() {(document, error ) in
            if error == nil {
                if let document = document, document.exists {
                    var socials = document.get(uid) as? [String] ?? []
                    if socials.contains(self.facebookLink) == false {
                    socials.append(self.facebookLink)
                    self.db.collection("Rooms").document(self.roomName).setData([uid: socials] ,merge: true)
                        let attributedString = NSMutableAttributedString(string: "Add me on Facebook")
                        let url = URL(string: self.facebookLink)
                        
                        let range = NSMakeRange(0, attributedString.length)
                        attributedString.setAttributes([.link: url], range: range)
                 
                        let facebookTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))

                        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16.0), range: range)

                        
                        
                        facebookTextView.attributedText = attributedString
                        facebookTextView.backgroundColor = UIColor.clear
                        facebookTextView.center = CGPoint(x: 160, y: self.y)
                        let linkAttributes: [NSAttributedString.Key: Any] = [
                            NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 0.42, green: 0.62, blue: 0.79, alpha: 1.0)]
                        facebookTextView.linkTextAttributes = linkAttributes
                        self.y += 25
                        facebookTextView.textAlignment = .center
                        facebookTextView.attributedText = attributedString
                        self.urlView.addSubview(facebookTextView)
                        self.urlView.isUserInteractionEnabled = true
                        facebookTextView.isEditable = false
                    }
                }
            }
            
        }
      
    }
    @IBAction func sendIG(_ sender: Any) {
        if(instagramLink == ""){
            return
        }
        let uid = Auth.auth().currentUser?.uid ?? ""
        db.collection("Rooms").document(roomName).getDocument() {(document, error ) in
            if error == nil {
                if let document = document, document.exists {
                    var socials = document.get(uid) as? [String] ?? []
                    if socials.contains(self.instagramLink) == false {
                    socials.append(self.instagramLink)
                    self.db.collection("Rooms").document(self.roomName).setData([uid: socials], merge: true)
                        let attributedString = NSMutableAttributedString(string: "Follow me on Instagram")
                        let url = URL(string: self.instagramLink)
                        
                        let range = NSMakeRange(0, attributedString.length)
                        attributedString.setAttributes([.link: url], range: range)
                 
                        let IGTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))

                        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16.0), range: range)

                        
                        IGTextView.attributedText = attributedString
                        IGTextView.center = CGPoint(x: 160, y: self.y)
                        let linkAttributes: [NSAttributedString.Key: Any] = [
                            NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 0.42, green: 0.62, blue: 0.79, alpha: 1.0)]
                        IGTextView.linkTextAttributes = linkAttributes
                        self.y += 25
                        IGTextView.textAlignment = .center
                        IGTextView.backgroundColor = UIColor.clear
                        IGTextView.attributedText = attributedString
                        self.urlView.addSubview(IGTextView)
                        self.urlView.isUserInteractionEnabled = true
                        IGTextView.isEditable = false
                    }
                }
            }
            
        }
        
    }
    @IBAction func sendLinkedin(_ sender: Any) {
        if(linkedinLink == ""){
            return
        }
        let uid = Auth.auth().currentUser?.uid ?? ""
        db.collection("Rooms").document(roomName).getDocument() {(document, error ) in
            if error == nil {
                if let document = document, document.exists {
                    var socials = document.get(uid) as? [String] ?? []
                    if socials.contains(self.linkedinLink) == false {
                    socials.append(self.linkedinLink)
                    self.db.collection("Rooms").document(self.roomName).setData([uid: socials], merge: true)
                        let attributedString = NSMutableAttributedString(string: "Connect with me on LinkedIn: \(self.linkedinLink)")
                        
                        let range = NSMakeRange(0, attributedString.length)
                 
                        let linkedinTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))

                        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16.0), range: range)

                        
                        linkedinTextView.attributedText = attributedString
                        linkedinTextView.center = CGPoint(x: 160, y: self.y)
                        let linkAttributes: [NSAttributedString.Key: Any] = [
                            NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 0.42, green: 0.62, blue: 0.79, alpha: 1.0)]
                        linkedinTextView.linkTextAttributes = linkAttributes
                        self.y += 25
                        linkedinTextView.textAlignment = .center
                        linkedinTextView.attributedText = attributedString
                        linkedinTextView.backgroundColor = UIColor.clear

                        self.urlView.addSubview(linkedinTextView)
                        self.urlView.isUserInteractionEnabled = true
                        linkedinTextView.isEditable = false
                     
                    }
                }
            }
            
        }
     
    }
    @IBAction func sendSnapchat(_ sender: Any) {
        if(snapchatLink == ""){
            return
        }
        let uid = Auth.auth().currentUser?.uid ?? ""
        db.collection("Rooms").document(roomName).getDocument() {(document, error ) in
            if error == nil {
                if let document = document, document.exists {
                    var socials = document.get(uid) as? [String] ?? []
                    if socials.contains(self.snapchatLink) == false {
                        socials.append(self.snapchatLink)
                    self.db.collection("Rooms").document(self.roomName).setData([uid: socials], merge: true)
                        let attributedString = NSMutableAttributedString(string: "Add me on Snapchat")
                        let url = URL(string: self.snapchatLink)
                        
                        let range = NSMakeRange(0, attributedString.length)
                        attributedString.setAttributes([.link: url], range: range)
                 
                        let snapchatTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
                        
                        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16.0), range: range)

                        
                        snapchatTextView.attributedText = attributedString
                        snapchatTextView.center = CGPoint(x: 160, y: self.y)
                        let linkAttributes: [NSAttributedString.Key: Any] = [
                            NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 0.42, green: 0.62, blue: 0.79, alpha: 1.0)]
                        snapchatTextView.linkTextAttributes = linkAttributes
                        self.y += 25
                        snapchatTextView.textAlignment = .center
                        snapchatTextView.backgroundColor = UIColor.clear
                        snapchatTextView.attributedText = attributedString
                        self.urlView.addSubview(snapchatTextView)
                        self.urlView.isUserInteractionEnabled = true
                        snapchatTextView.isEditable = false
                    }
                }
            }
            
        }
     
    }
    
    func addLinkToView(url: String) {
        
        var messageText = ""

        print(url)
        if url.contains("instagram") {
            messageText = "Follow me on Instagram"
            
        }
        else if url.contains("snapchat") {
            messageText =  "Add me on Snapchat"
           
            
        } else if url.contains("twitter") {
            messageText = "Follow me on Twitter"
            
        }
        else if url.contains("facebook") {
            messageText = "Add me on Facebook"
        }
        else {
            messageText = "Connect with me on LinkedIn: \(linkedinLink)"
        }
        let socialUrl = URL(string: url)

        let attributedString = NSMutableAttributedString(string: messageText)
        let range = NSMakeRange(0, attributedString.length)
        attributedString.setAttributes([.link: socialUrl ?? ""], range: range)
        let snapchatTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16.0), range: range)

        
        snapchatTextView.attributedText = attributedString
        snapchatTextView.center = CGPoint(x: 160, y: self.y)
        let linkAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 0.69, green: 0.63, blue: 1.0, alpha: 1.0)]
        snapchatTextView.linkTextAttributes = linkAttributes
        self.y += 25
        snapchatTextView.textAlignment = .center
        snapchatTextView.backgroundColor = UIColor.clear
        snapchatTextView.attributedText = attributedString
        self.urlView.addSubview(snapchatTextView)
        self.urlView.isUserInteractionEnabled = true
        snapchatTextView.isEditable = false
    }
    
    
    
   var questionTime = 0
    @objc func updateTimer(){
        db.collection("Rooms").document(roomName).getDocument(){ [self]
            (document, error) in
            if(error == nil){
                if let document = document, document.exists {
                    if document.get("Timer") != nil{
                        let time = document.get("Timer")
                        let curTime = Int(time as? String ?? "1000" ) ?? 1000
                        self.timerLabel.text = "Timer: " + String(curTime/60) + ":" + String(format: "%02d",curTime % 60)
                        if(curTime == 0){
                            self.room?.disconnect()
                            self.db.collection("Rooms").document(roomName).delete(){ err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("Document successfully removed!")
                                }
                            }
                            checkUpdates?.invalidate()
                            checkSentSocialsTimer?.invalidate()
                            let roomDict:[String: String] = ["room": self.roomName]
                            NotificationCenter.default.post(name: Notification.Name("didStopTimer"), object : nil, userInfo: roomDict)
                            self.goBackToLobby()
                        }
                    }
                    if document.get("Icebreaker") != nil{
                        let question = document.get("Icebreaker") as? String
                        messageLabel.isHidden = false
                        messageLabel.text = question  ?? "Error" + "\n"
                        
                    }
                    if document.get("Exited") != nil {
                        self.db.collection("Rooms").document(roomName).delete(){ err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                        exitRoom()
                    }
                }
            }
        }
        if questionTime == 10{
            db.collection("Rooms").document(roomName).updateData(["Icebreaker": FieldValue.delete()]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            messageLabel.isHidden = true
        }
        questionTime += 1
        
    }
    
    @objc func checkForSocials() {
        db.collection("Rooms").document(roomName).getDocument(){
            (document, error) in
            if(error == nil){
                if let document = document, document.exists {
                    let links = document.get(self.matchId) as? [String] ?? []
                    if links.count > self.sentSocialsCount {
                        self.sentSocialsCount += 1
                        self.addLinkToView(url: links[links.count-1] as? String ?? "")
                    }
                }
            }
        }
    }

    @IBAction func addTime(_ sender: Any) {
        db.collection("Rooms").document(roomName).getDocument(){
            (document, error) in
            if(error == nil){
                if let document = document, document.exists {
                    if document.get("Timer") != nil{
                        let time = document.get("Timer")
                        var curTime = Int(time as? String ?? "1000" ) ?? 1000
                        curTime = curTime + 60
                        self.db.collection("Rooms").document(self.roomName).setData(["Timer":String(curTime)])
                    }
                }
            }
        }
    }

    
  
    func setIsOnCall() {
        self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").getDocument{(document, error) in
            if let document = document, document.exists {
                document.reference.updateData([
                    "isOnCall": "false"
                ])
            }
        }
    }

    func addMatchToPrevMatches() {
        self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").collection("matches").document("previous matches").getDocument {(document, error)  in
            if let document = document, document.exists {
                var prev_matches = document.get("prev_matches") as? [String] ?? []
                prev_matches.append(self.matchId)
                self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").collection("matches").document("previous matches").setData(["prev_matches": prev_matches])
            }
        }
    }
    func deleteCurrentMatch() {
        self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").collection("matches").document("current match").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }

    }
    @IBAction func disconnect(sender: AnyObject) {
        self.db.collection("Rooms").document(self.roomName).setData(["Exited":"1"], merge: true)
        exitRoom()
    }
   
    func exitRoom(){
        self.room?.disconnect()
        checkUpdates?.invalidate()
        checkSentSocialsTimer?.invalidate()
        /*Add user to previous matches */
        self.addMatchToPrevMatches()
        
        /*Delete fields of current match for myself*/
        self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").collection("matches").document("current match").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        /* set is on call to false*/
        self.setIsOnCall()
        let roomDict:[String: String] = ["room": roomName]
        NotificationCenter.default.post(name: Notification.Name("didStopTimer"), object : nil, userInfo: roomDict)
        logMessage(messageText: "Attempting to disconnect from room \(String(describing: room?.name))")
        goBackToLobby()
    }
    func goBackToLobby(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let lobbyViewController = storyboard.instantiateViewController(identifier: "lobbyVC") as? LobbyViewController else {
            assertionFailure("couldn't find vc")
            return }
        //optional navigation controller
        navigationController?.pushViewController(lobbyViewController, animated: true)
    }
    var toggleMicState = 1;
    @IBAction func toggleMic(sender: AnyObject) {
        let micOn = UIImage(named:"Microphone Icon")
        let micOff = UIImage(named: "mute Microphone Icon")
        if (self.localAudioTrack != nil) {
            self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled ?? false)
            if(toggleMicState == 1){
                micImage.setImage(micOff, for: .normal)
                toggleMicState = 2
            }else{
                micImage.setImage(micOn, for: .normal)
                toggleMicState = 1
            }
        }
    }
    var toggleVidState = 1;
    @IBAction func toggleVid(_ sender: Any) {
        let vidOn = UIImage(named:"Video Icon")
        let vidOff = UIImage(named: "Close View Icon")
        if (self.localVideoTrack != nil) {
            self.localVideoTrack?.isEnabled = !(self.localVideoTrack?.isEnabled ?? false)
            if(toggleVidState == 1){
                vidImage.setImage(vidOff, for: .normal)
                toggleVidState = 2
            }else{
                vidImage.setImage(vidOn, for: .normal)
                toggleVidState = 1
            }
        }
    }
    
    func setupRemoteVideoView() {
        // Creating `VideoView` programmatically
        self.remoteView = VideoView(frame: CGRect.zero, delegate: self)

        self.view.insertSubview(self.remoteView, at: 0)
        
        // `VideoView` supports scaleToFill, scaleAspectFill and scaleAspectFit
        // scaleAspectFit is the default mode when you create `VideoView` programmatically.
        self.remoteView.contentMode = .scaleAspectFill;

        let centerX = NSLayoutConstraint(item: self.remoteView as Any,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         multiplier: 1,
                                         constant: 0);
        self.view.addConstraint(centerX)
        let centerY = NSLayoutConstraint(item: self.remoteView as Any,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         multiplier: 1,
                                         constant: 0);
        self.view.addConstraint(centerY)
        let width = NSLayoutConstraint(item: self.remoteView as Any,
                                       attribute: NSLayoutConstraint.Attribute.width,
                                       relatedBy: NSLayoutConstraint.Relation.equal,
                                       toItem: self.view,
                                       attribute: NSLayoutConstraint.Attribute.width,
                                       multiplier: 1,
                                       constant: 0);
        self.view.addConstraint(width)
        let height = NSLayoutConstraint(item: self.remoteView as Any,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                        toItem: self.view,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        multiplier: 1,
                                        constant: 0);
        self.view.addConstraint(height)
    }
    
    func connect(){
        // Configure access token either from server or manually.
        // If the default wasn't changed, try fetching from server.
       
        
        // Prepare local media which we will share with Room Participants.
       
        
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = ConnectOptions(token: accessToken) { (builder) in
            builder.roomName = self.roomName
           
            // Use the local media that we prepared earlier.
            if let audioTrack = self.localAudioTrack{
                builder.audioTracks = [audioTrack]
            }
            if let videoTrack = self.localVideoTrack{
                builder.videoTracks = [videoTrack]
            }
         
        }
        
        // Connect to the Room using the options we provided.
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        
        logMessage(messageText: "Attempting to connect to room")
        
    }
    
    func prepareLocalMedia() {

        // We will share local audio and video when we connect to the Room.

        // Create an audio track.
        if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack(options: nil, enabled: true, name: "Microphone")

            if (localAudioTrack == nil) {
                logMessage(messageText: "Failed to create audio track")
            }
        }
        
        guard let frontCamera = CameraSource.captureDevice(position: .front) else{
            self.logMessage(messageText:"No front capture device found!")
            return
        }
        


        

        let options = CameraSourceOptions { (builder) in
        }
        // Preview our local camera track in the local video preview view.
        guard let camera = CameraSource(options: options, delegate: self) else{
            self.logMessage(messageText:"No front capture device found!")
            return
        }
        
        localVideoTrack = LocalVideoTrack(source: camera, enabled: true, name: "Camera")
        localVideoTrack?.addRenderer(self.myView)
        // Add renderer to video track for local preview
        
        logMessage(messageText: "Video track created")

        camera.startCapture(device: frontCamera) { (captureDevice, videoFormat, error) in
            if let error = error {
                self.logMessage(messageText: "Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
            } else {
               
            }
        }
        
    
   }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
        messageLabel.text = messageText
    }
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
            if let subscribedVideoTrack = publication.remoteTrack,
                publication.isTrackSubscribed {
                setupRemoteVideoView()
                subscribedVideoTrack.addRenderer(self.remoteView)
                self.remoteParticipant = participant
                return true
            }
        }
        return false
    }

    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
                renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }

    func cleanupRemoteParticipant() {
        if self.remoteParticipant != nil {
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
}



// MARK:- RoomDelegate
extension MeetingViewController: RoomDelegate {
    func roomDidConnect(room: Room) {
        logMessage(messageText: "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")

        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
            // This would create another timer model class, which would not synconize with the other timer model
            // We need to create a timer API so both devices would be accessing the same timer model API
            
        }
        
    }

    func roomDidDisconnect(room: Room, error: Error?) {
        logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        
        self.cleanupRemoteParticipant()
        self.room = nil
        
        
    }

    func roomDidFailToConnect(room: Room, error: Error) {
        logMessage(messageText: "Failed to connect to room with error = \(String(describing: error))")
        self.room = nil
        
       
    }

    func roomIsReconnecting(room: Room, error: Error) {
        logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }

    func roomDidReconnect(room: Room) {
        logMessage(messageText: "Reconnected to room \(room.name)")
    }
   
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        participant.delegate = self
        
        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
        db.collection("PopRoom").document("Timer").setData(["Time":"300"])
        
        
    }

    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
       

        // Nothing to do in this example. Subscription events are used to add/remove renderers.
    }
}
// MARK:- RemoteParticipantDelegate
extension MeetingViewController : RemoteParticipantDelegate {

    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
    }

    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.

        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }

    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.

        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
    }

    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.
 
        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }

    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.

        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
        
        if (self.remoteParticipant == nil) {
            renderRemoteParticipant(participant: participant)
        }
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")

        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()

            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
               let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
                
            }
        }
    }

    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
       
        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }

    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
    }

    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
    }

    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }

    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }

    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }

    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}

// MARK:- VideoViewDelegate
extension MeetingViewController : VideoViewDelegate {
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
}

// MARK:- CameraSourceDelegate
extension MeetingViewController : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        logMessage(messageText: "Camera source failed with error: \(error.localizedDescription)")
    }
}


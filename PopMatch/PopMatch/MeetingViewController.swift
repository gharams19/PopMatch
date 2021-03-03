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

class MeetingViewController: UIViewController, TimerModelUpdates {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var myView: VideoView!
    @IBOutlet weak var addTimerButton: UIButton!
    @IBOutlet weak var micImage: UIButton!
    @IBOutlet weak var vidImage: UIButton!
    @IBOutlet weak var endImage: UIButton!
    
    var remoteView: VideoView!
    var room: Room?
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    var vidTimer: Timer?
    var runCount = 300;
    var roomName: String = ""
    var accessToken : String = ""
   
    @IBOutlet weak var sendMediaText: UILabel!
    @IBOutlet weak var twitter: UIButton!
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var snapchat: UIButton!
    @IBOutlet weak var ig: UIButton!
    @IBOutlet weak var linkedin: UIButton!
    @IBOutlet weak var urlTextView: UITextView!
    
    var db = Firestore.firestore()
    var storage = Storage.storage()
    
    var twitterLink: String = ""
    var facebookLink: String = ""
    var snapchatLink: String = ""
    var instagramLink: String = ""
    var linkedinLink: String = ""
    
    var links: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareLocalMedia()
        self.connect()
        self.messageLabel.adjustsFontSizeToFitWidth = true;
        self.messageLabel.minimumScaleFactor = 0.75;
        timerModel.delegate = self
        
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
        urlTextView.isEditable = false;
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        return self.room != nil
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
        flip = flip == 0 ? 1 : 0
    }
    
    @IBAction func sendTwitter(_ sender: Any) {
        if(twitterLink == ""){
            return
        }
        urlTextView.text += twitterLink + "\n"
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.clearURL), userInfo: nil, repeats: false)
    }
    @IBAction func sendFacebook(_ sender: Any) {
        if(facebookLink == ""){
            return
        }
        urlTextView.text += facebookLink + "\n"
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.clearURL), userInfo: nil, repeats: false)
    }
    @IBAction func sendIG(_ sender: Any) {
        if(instagramLink == ""){
            return
        }
        urlTextView.text += instagramLink + "\n"
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.clearURL), userInfo: nil, repeats: false)
    }
    @IBAction func sendLinkedin(_ sender: Any) {
        if(linkedinLink == ""){
            return
        }
        urlTextView.text += linkedinLink + "\n"
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.clearURL), userInfo: nil, repeats: false)
    }
    @IBAction func sendSnapchat(_ sender: Any) {
        if(snapchatLink == ""){
            return
        }
        urlTextView.text += snapchatLink + "\n"
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.clearURL), userInfo: nil, repeats: false)
    }
    @objc func clearURL(){
        var str = String(urlTextView.text)
        guard let index = str.firstIndex(of: "\n") else { return }
        str.removeSubrange(str.startIndex...index)
        urlTextView.text = str
    }
    
    let timerModel = TimerModel()
    
    func currentTimeDidChange(_ currentTime: Int) {
        timerLabel.text = "Timer: " + String(currentTime/60) + ":" + String(format: "%02d",currentTime % 60)
        if(currentTime == 0){
            self.room?.disconnect()
            goBackToLobby()
        }
    }
    
   
  
    @IBAction func addTime(_ sender: Any) {
        timerModel.addTime()
    }
    
    
    @IBAction func disconnect(sender: AnyObject) {
        self.room?.disconnect()
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
            timerModel.start();
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
        timerModel.start()
        
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


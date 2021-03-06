//
//  MatchingViewController.swift
//  PopMatch
//
//  Created by Gharam Alsaedi on 2/23/21.
//

import UIKit
import Firebase

class MatchingViewController: UIViewController {
    
    @IBOutlet weak var matchUsername: UILabel!
    @IBOutlet weak var matchImage: UIImageView!
    
    @IBOutlet weak var instruction: UILabel!
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var popUpName: UILabel!
    @IBOutlet weak var popUpPronoun: UILabel!
    @IBOutlet weak var popUpAge: UILabel!
    @IBOutlet weak var hobbiesAnswer: UILabel!
    @IBOutlet weak var showAnswer: UILabel!
    @IBOutlet weak var dietAnswer: UILabel!
    @IBOutlet weak var musicAnswer: UILabel!
    @IBOutlet weak var majorAnswer: UILabel!
    
    var matchId = ""
    var matchName = ""
    var matchedOn = ""
    var rejectedMatches = [String]()
    var db = Firestore.firestore()
    var username = ""
    var roomName = "PopRoom"
    let placeholderImage = UIImage(named: "bubble1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.matchUsername.text = ""
        self.popUpName.text = ""
        self.popUpAge.text = ""
        self.popUpPronoun.text = ""
        self.hobbiesAnswer.text = ""
        self.showAnswer.text = ""
        self.dietAnswer.text = ""
        self.musicAnswer.text = ""
        self.majorAnswer.text = ""
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopTimer(_:)), name: Notification.Name("didStopTimer"), object: nil)
        
        setup()
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        matchImage.addGestureRecognizer(imageTap)
        matchImage.isUserInteractionEnabled = true
        
        popUpView.layer.borderWidth = 2.5
        popUpView.layer.borderColor = UIColor(displayP3Red: 1.0, green: 0.54, blue: 0.11, alpha: 1.0).cgColor
        
        popUpView.isHidden = true
        
    }
    
    
    func setup() {
        let db = Firestore.firestore()
        
        //set username for auth token
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").getDocument{ (document, error) in
            if(error == nil){
                if let document = document, document.exists {
                    self.username = document.get("first name") as? String ?? ""
                }
            }
            
        }
        
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").collection("matches").document("current match").getDocument{ (document, error) in
            if let document = document, document.exists {
                self.matchId = document.get("match id") as? String ?? ""
                db.collection("users").document(self.matchId).getDocument { (document, error) in
                    if let document = document, document.exists {
                        self.matchName = document.get("first name") as? String ?? ""
                        
                        let username = document.get("username") as? String ?? ""
                        if username.count == 0 {
                            self.matchUsername.text = self.matchName
                            self.instruction.text = "Tap on image to view \(self.matchName)'s information"
                            self.popUpName.text = self.matchName
                        }
                        else {
                            self.matchUsername.text = username
                            self.instruction.text = "Tap on image to view \(username)'s information"
                            self.popUpName.text = username
                            
                        }
                        if let image = document.get("image") {
                            let imageUrl = image as? String ?? ""
                            self.matchImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: self.placeholderImage)
                            // self.profileImage.sizeToFit()
                            self.matchImage.layer.cornerRadius = 0.5 * self.matchImage.layer.bounds.size.width
                            self.matchImage.layer.borderWidth = 8.0
                            self.matchImage.layer.borderColor = UIColor(displayP3Red: 0.91, green: 0.87, blue: 1.0, alpha: 1.0).cgColor
                            self.matchImage.contentMode = .scaleAspectFill
                        }
                    }
                    
                    
                }
                
                
            }
            db.collection("users").document(self.matchId).collection("questions").document("friendship").getDocument{(document, error) in
                if let document = document, document.exists {
                    
                    let data = document.data() as? [String: Any]
                    
                    self.majorAnswer.text = data?["major"] as? String ?? ""
                    let hobbies = data?["hobbies"] as? [String] ?? []
                    var hobbiesText = ""
                    var musicText = ""
                    var showsText = ""
                    
                    for hobby in hobbies{
                        if hobby != hobbies.first {
                            hobbiesText += "\n"
                        }
                        hobbiesText += "-\(hobby)"
                    }
                    
                    self.hobbiesAnswer.numberOfLines = 0
                    self.hobbiesAnswer.text = hobbiesText
                    
                    let music = data?["music"] as? [String] ?? []
                    
                    for genre in music{
                        if genre != music.first {
                            musicText += "\n"
                        }
                        musicText += "-\(genre)"
                        
                    }
                    self.musicAnswer.numberOfLines = 0
                    self.musicAnswer.text = musicText
                    
                    let shows = data?["tvShows"] as? [String] ?? []
                    
                    for show in shows {
                        if show != shows.first {
                            showsText += "\n"
                        }
                        showsText += "-\(show)"
                    }
                    
                    self.showAnswer.numberOfLines = 0
                    self.showAnswer.text = showsText
                    
                    self.dietAnswer.text = data?["diet"] as? String ?? ""
                    
                    self.popUpAge.text = data?["ageGroup"] as? String ?? ""
                    if(self.popUpAge.text != "") {
                        self.popUpAge.text = ",\(self.popUpAge.text)"
                    }
                    self.popUpPronoun.text = data?["pronoun"] as? String ?? ""
                    if(self.popUpPronoun.text != "" || self.popUpPronoun.text != "Decline to state") {
                        self.popUpPronoun.text = ",\(self.popUpPronoun.text)"
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func goBackToProfileVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let profileViewController = storyboard.instantiateViewController(withIdentifier: "profileVC") as? ProfileViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    
    
    
    @objc func currentTimeDidChange() {
        db.collection("Rooms").document(roomName).getDocument(){
            (document, error) in
            if(error == nil){
                if let document = document, document.exists {
                    if document.get("Timer") != nil{
                        let time = document.get("Timer")
                        var curTime = Int(time as? String ?? "1000" ) ?? 1000
                        curTime = curTime - 1
                        self.db.collection("Rooms").document(self.roomName).setData(["Timer":String(curTime)], merge: true)
                    }
                }
            }
        }
    }
    var vidTimer : Timer?
    func startTimer(){
        db.collection("Rooms").document(roomName).setData(["Timer":"300"], merge: true)
        vidTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.currentTimeDidChange), userInfo: nil, repeats: true)
    }
    
    @objc func stopTimer(_ notification: Notification){
        if let room = notification.userInfo?["room"] as? String {
            if(room == self.roomName){
                vidTimer?.invalidate()
            }
          }
    }
    
    func acceptMatch() {
        
        db.collection("Rooms").document(roomName).getDocument(){
            (document, error) in
            if(error == nil){
                if let document = document, document.exists {
                    //If opponent is in waiting room
                    if document.get(self.matchName) != nil{
                        self.db.collection("Rooms").document(self.roomName).setData(["Entered":"1"], merge: true)
                        self.enterVideo()
                        self.startTimer()
                    }
                    //If opponent rejected
                    if document.get("Rejected") != nil{
                        self.db.collection("Rooms").document(self.roomName).delete()
                        self.goToLobby()
                    }
                }else{
                    // Go to waiting room to wait for the others response
                    self.db.collection("Rooms").document(self.roomName).setData([self.username:"1"], merge: true)
                   
                    self.enterWaitingRoom()
                }
            }
        }
    }
    func enterVideo(){
        let userToken = self.getToken()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let meetingViewController = storyboard.instantiateViewController(withIdentifier: "meetingVC") as? MeetingViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        // need to gernerate tokens for each user
        meetingViewController.accessToken = userToken
        meetingViewController.roomName = roomName
        navigationController?.pushViewController(meetingViewController, animated: true)
    }
    
    func enterWaitingRoom(){
        let userToken = self.getToken()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let preMeetingViewController = storyboard.instantiateViewController(withIdentifier: "preMeetingVC") as? PreMeetingViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        // need to gernerate tokens for each user
        preMeetingViewController.accessToken = userToken
        preMeetingViewController.roomName = "PopRoom"
        preMeetingViewController.username = username
        preMeetingViewController.matchName = matchName
        navigationController?.pushViewController(preMeetingViewController, animated: true)
    }
    func getToken() ->String{
        
        var accessToken = ""
        do {
            accessToken = try fetchToken()
        } catch {
            print("Failed to fetch access token")
            return ""
        }
        accessToken = String(accessToken.dropFirst(10))
        return accessToken
    }
    
    func fetchToken() throws -> String {
        var token: String = "TWILIO_ACCESS_TOKEN"
        var tokenURL = "https://glaucous-centipede-6895.twil.io/video-token?identity="
        tokenURL.append(username)
        guard let requestURL: URL = URL(string: tokenURL) else{
            print("Token URL not found")
            return ""
        }
        do {
            let data = try Data(contentsOf: requestURL)
            if let tokenReponse = String(data: data, encoding: String.Encoding.utf8) {
                token = tokenReponse
            }
        } catch let error as NSError {
            print ("Invalid token url, error = \(error)")
            throw error
        }
        return token
    }
    
    func rejectMatch() {
        db.collection("Rooms").document(roomName).getDocument(){
            (document, error) in
            if(error == nil){
                if let document = document, document.exists {
                    if document.get("Rejected") != nil{
                        self.db.collection("Rooms").document(self.roomName).delete()
                    }else{
                        self.db.collection("Rooms").document(self.roomName).setData(["Rejected":"1"])
                    }
                }
                else{
                    self.db.collection("Rooms").document(self.roomName).setData(["Rejected":"1"])
                }
            }
        }
        
                    
        
        /*Add user to rejectedMatches array*/
        rejectedMatches.append(matchName)
        goToLobby()
       
        
    }
    func goToLobby(){
        /*Go to lobbyVC to find another */
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let lobbyViewController = storyboard.instantiateViewController(withIdentifier: "lobbyVC") as? LobbyViewController else {
            assertionFailure("couldn't find vc") //will stop program
            return
        }
        //optional navigation controller
        self.navigationController?.pushViewController(lobbyViewController, animated: true)
    }
    @IBAction func invokeAcceptMatchFunc(_ sender: Any) {
        acceptMatch()
    }
    
    @IBAction func invokeRejectMatchFunc(_ sender: Any) {
        rejectMatch()
    }
    
    @objc func imageTapped() {
        popUpView.isHidden = false
        backButton.isUserInteractionEnabled = false
        acceptButton.isUserInteractionEnabled = false
        rejectButton.isUserInteractionEnabled = false
    }
    
    @IBAction func closePopUpView(_ sender: Any) {
        popUpView.isHidden = true
        backButton.isUserInteractionEnabled = true
        acceptButton.isUserInteractionEnabled = true
        rejectButton.isUserInteractionEnabled = true
    }
}

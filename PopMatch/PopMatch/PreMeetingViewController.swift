//
//  PreMeetingViewController.swift
//  PopMatch
//
//  Created by Ray Ngan on 3/5/21.
//

import UIKit
import Firebase

class PreMeetingViewController: UIViewController {
    
    
    @IBOutlet weak var bubble: UIImageView!
    var displayLink: CADisplayLink!
    var value: CGFloat = 0.0
    var waitTime = 0
    var invert: Bool = false
    var roomName: String = ""
    var accessToken : String = ""
    var waitTimer : Timer?
    var db = Firestore.firestore()
    var username = ""
    var matchName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLink = CADisplayLink(target: self, selector: #selector(handleAnimations))
        displayLink.add(to: RunLoop.main, forMode: .default)
        waitTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.checkIfRoomIsReady), userInfo: nil, repeats: true)
    }
    
    
    
    @objc func handleAnimations() {
        invert ? (value -= 1) : (value += 1)
        bubble.alpha = (value / 100)
        if ( value > 100 || value < 0) {
            invert = !invert
        }
    }
    @objc func checkIfRoomIsReady(){
        db.collection("Rooms").document(roomName).getDocument(){
            (document, error) in
            if(error == nil){
                if let document = document, document.exists {
                    if document.get("Entered") != nil{
                        self.enterVideo()
                        self.waitTimer?.invalidate()
                    }
                    if document.get("Rejected") != nil{
                        self.db.collection("Rooms").document(self.roomName).delete()
                        self.goBackToLobby()
                    }
                    
                }
                
            }
            
        }
//        waitTime += 1
//        if(waitTime == 15){
//            self.db.collection("Rooms").document(self.roomName).delete()
//            goBackToLobby()
//        }
    }
    
    func enterVideo(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let meetingViewController = storyboard.instantiateViewController(withIdentifier: "meetingVC") as? MeetingViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        // need to gernerate tokens for each user
        meetingViewController.accessToken = accessToken
        meetingViewController.roomName =  roomName
        navigationController?.pushViewController(meetingViewController, animated: true)
    }
    func goBackToLobby(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let lobbyViewController = storyboard.instantiateViewController(identifier: "lobbyVC") as? LobbyViewController else {
            assertionFailure("couldn't find vc")
            return }
        //optional navigation controller
        navigationController?.pushViewController(lobbyViewController, animated: true)
    }
}

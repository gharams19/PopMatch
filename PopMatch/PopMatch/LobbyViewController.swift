//
//  lobbyViewController.swift
//  PopMatch
//
//  Created by Ray Ngan on 2/21/21.
//

import UIKit
import Firebase
import AVFoundation

class LobbyViewController: UIViewController {

    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var bubbleZoom: UIImageView!
    @IBOutlet weak var headerLabel1: UILabel!
    @IBOutlet weak var headerLabel2: UILabel!
    
    var matches = [String: String]()
    var answers = [String: [String]] ()
    var currUid = ""
    var audioPlayer = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currUid = Firebase.Auth.auth().currentUser?.uid ?? ""
        getUserInfo()
        
        let sound = Bundle.main.path(forResource: "mixkit-soap-bubble-sound-2925", ofType: "wav")
        do {
            //try to initialize to sound above
            audioPlayer = try AVPlayer(url: URL(fileURLWithPath: sound ?? ""))
        }
        catch{
            print(error)
        }
        
        //setup
        bubbleZoom.isHidden = true
        bubbleView.backgroundColor = .white
        self.view.addSubview(bubbleView)
        
        //adding the floating bubbles with continuous animation
        var array: [UIImageView] = []
        let userNumber = 10
        for _ in 0...userNumber-1 {
            let bubbleImageView = UIImageView(image: #imageLiteral(resourceName: "bubble2 copy"))
            bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
            array.append(bubbleImageView)
        }
        for i in 0...userNumber-1 {
            array[i].frame = CGRect(x: bubbleView.center.x, y: bubbleView.center.y, width: 100, height: 100)
            bubbleView.addSubview(array[i])
            animation(image: array[i])
        }
        
        
       
    }
    var previousAnimation = Int()
    
    func animation(image: UIImageView) {
        let maxX = self.bubbleView.frame.maxX - CGFloat(100)
        let maxY = self.bubbleView.frame.height - CGFloat(100)
        var newX = UInt32(0)
        var newY = UInt32(0)
        
        //decide randomly which direction to go into
        var sideDecider = Int.random(in: 1...4)
        
        //added to make it less likely bubbles will overlap
        if previousAnimation == sideDecider && sideDecider < 4 {
            sideDecider += 1
        } else if previousAnimation == sideDecider && sideDecider == 4 {
            sideDecider = 1
        }
        
        switch sideDecider {
        case 1:
            newX = UInt32(maxX)
            newY = 0
        case 2:
            newX = UInt32(maxX)
            newY = UInt32(maxY)
        case 3:
            newX = 0
            newY = UInt32(maxY)
        case 4:
            newX = 0
            newY = 0
        default:
            newX = 0
            newY = 0
        }
        previousAnimation = sideDecider
        
        //calculation of distance to have the speed of the bubble be constant
        var distanceX = UInt32(0)
        var distanceY = UInt32(0)
        if newX > UInt32(image.center.x) {
            distanceX = newX - UInt32(image.center.x)
        } else {
            distanceX = UInt32(image.center.x) - newX
        }
        if newY > UInt32(image.center.y) {
            distanceY = newY - UInt32(image.center.y)
        } else {
            distanceY = UInt32(image.center.y) - newY
        }
    
        let totalDistance = sqrt(Double(distanceX * distanceX)) + sqrt(Double(distanceY * distanceY))
        let velocity = 125
        UIView.animate(withDuration: totalDistance / Double(velocity), delay: 0, options: .curveLinear, animations: {
            image.frame.origin.x = CGFloat(newX)
            image.frame.origin.y = CGFloat(newY)
            image.layoutIfNeeded()
        }, completion:
        { finished in
            self.animation(image: image)
        }
        )
    }
    
    @IBAction func backButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let profileViewController = storyboard.instantiateViewController(withIdentifier: "profileVC") as? ProfileViewController else {
                assertionFailure("couldn't find vc") //will stop program
                return
            }
        //optional navigation controller
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    /*Get current user's answers to questions*/
    func getUserInfo() {
        let db = Firestore.firestore()
        db.collection("users").document(self.currUid).collection("questions").document("friendship").getDocument{(document, error) in
            if let document = document, document.exists {
                let data = document.data() as? [String: Any]
                
                self.answers["major"] = [data?["major"] as? String ?? ""]
                self.answers["hobbies"] = data?["hobbies"] as? [String]
                self.answers["music"] = data?["music"] as? [String]
            }
           
            self.findMatches()
           
        }
        
       
    }
    
    func findMatches() {
        let db = Firestore.firestore()
        
        DispatchQueue.global().async(execute: {
            
            /*Check if they matched with someone already */
            var semaphore = DispatchSemaphore(value: 0)
            
            var prevmatchId = ""
            var matchState = ""
            
            db.collection("users").document(self.currUid).collection("matches").document("current match").getDocument{(document, error) in
                if let document = document, document.exists {
                    let data = document.data() as? [String: String]
                    
                    /*Matched with someone, gget that user's id*/
                    if data?["match id"] ?? "" != "" {
                        prevmatchId = data?["match id"] ?? ""
                        Database.database().reference().child("status").child(prevmatchId).observe(.value, with: { (snapshot) in
                            let value = snapshot.value as? [String:Any]
                            matchState = value?.first?.value as? String ?? ""
                            semaphore.signal()
                        })
                    }
                    else {
                        semaphore.signal()
                    }
                }
                else {
                    semaphore.signal()
                }
            }
            
            // wait for previous task to finish
            semaphore.wait()
            
            /*They weren't matched with anyone before, find a new match*/
            if prevmatchId == "" || (matchState == "offline") {
                
                semaphore = DispatchSemaphore(value: 0)
                
                /*Get all users from realtime database and only add people that are online*/
                let ref = Database.database().reference().child("status")
                ref.observeSingleEvent(of:.value, with: { snapshot in
                    let children = snapshot.children.allObjects as? [DataSnapshot] ?? [DataSnapshot()]
                    for child in children {
                        
                        let uid = child.key
                        let value = child.value as? [String:Any]
                        let state = value?.values.first as? String ?? ""
                        
                        if uid == self.currUid  {
                            continue
                        }
                        if state == "online" {
                            self.matches[uid] = ""
                        }
                        
                    }
                    
                    semaphore.signal()
                })
                
                semaphore.wait()

                /*No users are online*/
                if(self.matches.isEmpty) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        print("No Matches Found!")
                        self.headerLabel1.text = "No bubbles to pop"
                        self.headerLabel2.text = "Try again later"
                        return
                    }
                    return
                }
                semaphore = DispatchSemaphore(value: 0)
                var i = 0
                
                /*get the bool variable isOnCall that is true if user is unavailable */
                for match in self.matches {
                
                    let docRef = db.collection("users").document(match.key)
                    
                    
                    docRef.getDocument {(document, error) in
                        i+=1
                        if i == self.matches.count {
                            semaphore.signal()
                        }
                        if let document = document, document.exists {
                            var isOnCall = document.get("isOnCall") as? String ?? "false"
                            if isOnCall == "" {
                                isOnCall = "false"
                            }
                            self.matches.updateValue(isOnCall, forKey: match.key)
                            
                        }
                        
                    }
                    
                }

                
                semaphore.wait()

                /*Remove matches that are busy*/
                self.matches = self.matches.filter{$0.value == "false" || $0.value == ""}
                
                var matchId = ""
                var matchedOn = ""
                
                /*No matches left*/
                if(self.matches.isEmpty) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        print("No Matches Found!")
                        self.headerLabel1.text = "No bubbles to pop"
                        self.headerLabel2.text = "Try again later"
                        return
                    }
                    return
                   
                }
                else {
                    /*Find the most ideal match, if not found match with first person*/
                    for match in self.matches {
                        var matchAnswers = [String:[String]]()
                        
                        db.collection("users").document(match.key).collection("questions").document("friendship").getDocument{(document, error) in
                            if let document = document, document.exists {
                                
                                let data = document.data() as? [String: Any]
                                
                                matchAnswers["major"] = [data?["major"] as? String ?? ""]
                                matchAnswers["hobbies"] = data?["hobbies"] as? [String]
                                matchAnswers["music"] = data?["music"] as? [String]
                            }
                            if self.answers["major"] == matchAnswers["major"] {
                                matchId = match.key
                                matchedOn = "major"
                                print(matchId)
                            }
                            else {
                                for hobby in matchAnswers["hobbies"] ?? [] {
                                    if self.answers["hobbies"]?.contains(hobby) == true {
                                        if matchId == "" {
                                            matchId = match.key
                                            matchedOn = "hobby: \(hobby)"
                                            break
                                        }
                                        
                                    }
                                }
                                for music in matchAnswers["music"] ?? [] {
                                    if self.answers["music"]?.contains(music) == true {
                                        if matchId == "" {
                                            matchId = match.key
                                            matchedOn = "music: \(music)"
                                            break
                                        }
                                        
                                    }
                                }
                            }
                            /*Found a match*/
                            if matchId != "" {
                                print("Ideal Match Found")
                                
                                /*set current match variable in firestore */
                                let docData1: [String: Any] = [
                                    "match id": matchId,
                                    "matched on": matchedOn,
                                ]
                                let docData2: [String: Any] = [
                                    "match id": self.currUid,
                                    "matched on": matchedOn,
                                ]
                                db.collection("users").document(self.currUid).collection("matches").document("current match").setData(docData1) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    }
                                    else{
                                        print("Document successfully written with id \(self.currUid)")
                                    }
                                    
                                }
                                db.collection("users").document(matchId).collection("matches").document("current match").setData(docData2) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    }
                                    else{
                                        print("Document successfully written with id \(matchId)")
                                    }
                                    /*Move to matchhingVC*/
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                        self.bubbleZoom.transform = CGAffineTransform.identity
                                        self.bubbleZoom.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                                        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut , animations: {
                                            self.bubbleZoom.isHidden = false
                                            self.bubbleZoom.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                        }, completion: { finished in
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            guard let matchingViewController = storyboard.instantiateViewController(withIdentifier: "matchingVC") as? MatchingViewController else {
                                                assertionFailure("couldn't find vc")
                                                return
                                            }
                                            
                                            self.navigationController?.pushViewController(matchingViewController, animated: false)
                                        })
                                    }                            }
                                
                                
                            }
                            else {
                                /*Match is not ideal*/
                                print("Match Found")
                                matchId = self.matches.first?.key ?? ""
                                matchedOn = "nothing"
                                
                                let docData1: [String: Any] = [
                                    "match id": matchId,
                                    "matched on": matchedOn,
                                ]
                                let docData2: [String: Any] = [
                                    "match id": self.currUid,
                                    "matched on": matchedOn,
                                ]
                                db.collection("users").document(self.currUid).collection("matches").document("current match").setData(docData1) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    }
                                    else{
                                        print("Document successfully written with id \(self.currUid)")
                                    }
                                    
                                }
                                db.collection("users").document(matchId).collection("matches").document("current match").setData(docData2) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    }
                                    else{
                                        print("Document successfully written with id \(matchId)")
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                        self.bubbleZoom.transform = CGAffineTransform.identity
                                        self.bubbleZoom.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                                        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut , animations: {
                                            self.bubbleZoom.isHidden = false
                                            self.bubbleZoom.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                        }, completion: { finished in
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            guard let matchingViewController = storyboard.instantiateViewController(withIdentifier: "matchingVC") as? MatchingViewController else {
                                                assertionFailure("couldn't find vc")
                                                return
                                            }
                                            
                                            self.navigationController?.pushViewController(matchingViewController, animated: false)
                                        })
                                    }                            }
                            }
                        }
                        
                    }
                    
                    
                }
            }
            else {
                /*Matched already from other person*/
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.bubbleZoom.transform = CGAffineTransform.identity
                    self.bubbleZoom.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                    UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut , animations: {
                        self.bubbleZoom.isHidden = false
                        self.bubbleZoom.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }, completion: { finished in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        guard let matchingViewController = storyboard.instantiateViewController(withIdentifier: "matchingVC") as? MatchingViewController else {
                            assertionFailure("couldn't find vc")
                            return
                        }
                        
                        self.navigationController?.pushViewController(matchingViewController, animated: false)
                    })
                }
            }
        })
    }
}

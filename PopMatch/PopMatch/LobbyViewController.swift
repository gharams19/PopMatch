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
    var idealMatches = [String:[String]]()
    var answers = [String: [String]] ()
    var prev_matches = [String] ()
    var suspended = false
    var queue = DispatchQueue.global(qos: .userInitiated)
    var currUid = ""
    var audioPlayer = AVPlayer()
    var userNumber = 0
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
               var dontSearch = false
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
        queue.suspend()
        self.suspended = true
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.findMatches()
            }
        
        }
        
    }
    
    func findMatches() {
        var matches = [String: String]()
        if self.suspended == true {
            return
        }
        self.queue.async(execute: {
            /*Check if they matched with someone already */
            var semaphore = DispatchSemaphore(value: 0)
            let db = Firestore.firestore()
            db.collection("users").document(self.currUid).collection("matches").document("previous matches").getDocument{ (document, error) in
                if let document = document, document.exists {
                    self.prev_matches = document.get("prev_matches") as? [String] ?? []
                }
                else {
                    db.collection("users").document(self.currUid).collection("matches").document("previous matches").setData(["prev matches": []])
                }
                semaphore.signal()
        
            }

            var prevmatchId = ""
            var matchState = ""
            semaphore.wait()
            print(self.prev_matches)

            semaphore = DispatchSemaphore(value: 0)
            db.collection("users").document(self.currUid).collection("matches").document("current match").getDocument{(document, error) in
                if let document = document, document.exists {
                    let matchid = document.get("match id") as? String ?? ""
                    /*Matched with someone, gget that user's id*/
                    if matchid != "" {
                        prevmatchId = matchid
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
        
                        if state == "online" && self.prev_matches.contains(uid) == false && self.currUid != uid{
                            matches[uid] = ""
                        }
                        
                    }
                    
                    semaphore.signal()
                })
                
                semaphore.wait()
                /*No users are online*/
                if(matches.isEmpty) {
                    DispatchQueue.main.async {
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
                for match in matches {
                
                    let docRef = db.collection("users").document(match.key)
                    
                    
                    docRef.getDocument {(document, error) in
                        i+=1
                        if i == matches.count {
                            semaphore.signal()
                        }
                        if let document = document, document.exists {
                            var isOnCall = document.get("isOnCall") as? String ?? "false"
                            if isOnCall == "" {
                                isOnCall = "false"
                            }
                            matches.updateValue(isOnCall, forKey: match.key)
                            
                        }
                        
                    }
                    
                }

                
                semaphore.wait()

                /*Remove matches that are busy*/
                matches = matches.filter{$0.value == "false" || $0.value == ""}
                
                var matchId = ""
                var matchedOn = [String]()
                
                /*No matches left*/
                if(matches.isEmpty == true) {
                    DispatchQueue.main.async {
                        print("No Matches Found!")
                        self.headerLabel1.text = "No bubbles to pop"
                        self.headerLabel2.text = "Try again later"
                        return
                    }
                    return
                   
                }
                else {
                    var foundIdealmatch = false
                    /*Find the most ideal match, if not found match with first person*/
                    semaphore = DispatchSemaphore(value: 0)

                    for (index, match) in matches.enumerated() {
                        var matchAnswers = [String:[String]]()
                        matchedOn.removeAll()
                        db.collection("users").document(match.key).collection("questions").document("friendship").getDocument{(document, error) in
                            if let document = document, document.exists {
                    
                                matchAnswers["major"] = [document.get("major") as? String ?? ""]
                                matchAnswers["hobbies"] = document.get("hobbies") as? [String] ?? []
                                matchAnswers["music"] = document.get("music") as? [String] ?? []
                            
                            if self.answers["major"] == matchAnswers["major"] {
                                matchId = match.key
                                let major = matchAnswers["major"]?.first ?? ""
                                if !matchedOn.contains(major) {
                                    matchedOn.append(major)
                                }
                                foundIdealmatch = true
                            }
                                for hobby in matchAnswers["hobbies"] ?? [] {
                                    if self.answers["hobbies"]?.contains(hobby) == true {
                                            matchId = match.key
                                            matchedOn.append(hobby)
                                    }
                                    foundIdealmatch = true
                                }
                                for music in matchAnswers["music"] ?? [] {
                                    if self.answers["music"]?.contains(music) == true {
                                      
                                            matchId = match.key
                                            matchedOn.append(music)
                                    
                                        
                                    }
                                    foundIdealmatch = true
                                }
                                
                            
                            if !matchedOn.isEmpty  {
                    
                                self.idealMatches[match.key] = matchedOn
                            }
                            }
                            if index == 0 {
                            semaphore.signal()
                            }
                        }
                    }
                    semaphore.wait()
                            /*Found a match*/
                    if self.idealMatches.isEmpty == false {
                                print("Ideal Match Found")
                                print("ideal matches \(self.idealMatches)")
                                let result = self.idealMatches.sorted(by: {$0.1.count > $1.1.count})
                                print(result)
                                matchId = result.first?.key ?? ""
                                /*set current match variable in firestore */
                                let docData1: [String: Any] = [
                                    "match id": matchId,
                                    "matched on": matchedOn,
                                    "choice": ""
                                ]
                                let docData2: [String: Any] = [
                                    "match id": self.currUid,
                                    "matched on": matchedOn,
                                    "choice": ""
                                ]

                                db.collection("users").document(self.currUid).collection("matches").document("current match").setData(docData1) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    }
                                    else{
                                        print("Document successfully written with id \(self.currUid)")
                                    }
                                    db.collection("users").document(self.currUid).getDocument{(document, error) in
                                        if let document = document, document.exists {
                                            document.reference.updateData([
                                                "isOnCall": "true"
                                            ])
                                        }
                                    }
                                        db.collection("users").document(matchId).getDocument{(document, error) in
                                            if let document = document, document.exists {
                                                document.reference.updateData([
                                                    "isOnCall": "true"
                                                ])
                                            }
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
                                    DispatchQueue.main.async {
                                        self.bubbleZoom.transform = CGAffineTransform.identity
                                        self.bubbleZoom.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                                        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut , animations: {
                                            self.bubbleZoom.isHidden = false
                                            self.bubbleZoom.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                            self.audioPlayer.play()
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
                                
                            }
                            else {
                                /*Match is not ideal*/
                                print("Match Found")
                                matchId = matches.first?.key ?? ""
                                
                                
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
                                    db.collection("users").document(self.currUid).getDocument{(document, error) in
                                        if let document = document, document.exists {
                                            document.reference.updateData([
                                                "isOnCall": "true"
                                            ])
                                        }
                                    }
                                        db.collection("users").document(matchId).getDocument{(document, error) in
                                            if let document = document, document.exists {
                                                document.reference.updateData([
                                                    "isOnCall": "true"
                                                ])
                                            }
                                        }
                                    
                                }
                                db.collection("users").document(matchId).collection("matches").document("current match").setData(docData2) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    }
                                    else{
                                        print("Document successfully written with id \(matchId)")
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.bubbleZoom.transform = CGAffineTransform.identity
                                        self.bubbleZoom.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                                        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut , animations: {
                                            self.bubbleZoom.isHidden = false
                                            self.bubbleZoom.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                            self.audioPlayer.play()
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
            else {
                /*Matched already from other person*/
                DispatchQueue.main.async {
                    self.bubbleZoom.transform = CGAffineTransform.identity
                    self.bubbleZoom.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                    UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut , animations: {
                        self.bubbleZoom.isHidden = false
                        self.bubbleZoom.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.audioPlayer.play()
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

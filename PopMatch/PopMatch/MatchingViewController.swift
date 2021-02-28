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
    
    var matchName = ""
    var rejectedMatches = [String]()
    var db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let docRef = db.collection("users").document("Lr4b4gJoa9aM9qtD0LVX")
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                self.matchName = document.get("first name") as? String ?? ""
                
                let username = document.get("username") as? String ?? ""
                if username.count == 0 {
                    self.matchUsername.text = self.matchName
                    self.instruction.text = "Tap on image to view \(self.matchName)'s information"
                }
                else {
                    self.matchUsername.text = username
                    self.instruction.text = "Tap on image to view \(username)'s information"
                }
            } else {
                print("Document does not exist")
            }
            
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))

        matchImage.addGestureRecognizer(imageTap)
        matchImage.isUserInteractionEnabled = true
        
        popUpView.layer.borderWidth = 2.5
        popUpView.layer.borderColor = UIColor(displayP3Red: 1.0, green: 0.54, blue: 0.11, alpha: 1.0).cgColor
          
        popUpView.isHidden = true
    
        
        
    }
    
    
    
    @IBAction func goBackToProfileVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let profileViewController = storyboard.instantiateViewController(withIdentifier: "profileVC") as? ProfileViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    @objc func swipe(gesture: UISwipeGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case .right:
                acceptMatch()
            case .left:
                rejectMatch()
            default:
                break
            }
        }
    }
    var username = "Username"
    func acceptMatch() {
        let userToken = self.getToken()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let meetingViewController = storyboard.instantiateViewController(withIdentifier: "meetingVC") as? MeetingViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        // need to gernerate tokens for each user
        meetingViewController.accessToken = userToken
        meetingViewController.roomName = "PopRoom"
        navigationController?.pushViewController(meetingViewController, animated: true)
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
        /*Add user to rejectedMatches array*/
        rejectedMatches.append(matchName)
        
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

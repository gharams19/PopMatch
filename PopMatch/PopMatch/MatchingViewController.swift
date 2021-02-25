//
//  MatchingViewController.swift
//  PopMatch
//
//  Created by Gharam Alsaedi on 2/23/21.
//

import UIKit

class MatchingViewController: UIViewController {
    
    @IBOutlet weak var matchUsername: UILabel!
    @IBOutlet weak var matchImage: UIImageView!
    
    
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    let matchName = ""
    var rejectedMatches = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //matchUsername.text = nil
        
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
                print("Swiped right")
                acceptMatch()
            case .left:
                print("Swiped left")
                rejectMatch()
            default:
                break
            }
        }
    }
    
    func acceptMatch() {
        /*Check if match accepted too*/
        //if yes, go to meetingVC
        
        //if no, go to lobbyVC
    }
    
    func rejectMatch() {
        /*Add user to rejectedMatches array*/
        
        /*Go to lobbyVC to find another */
        
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

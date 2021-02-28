//
//  lobbyViewController.swift
//  PopMatch
//
//  Created by Ray Ngan on 2/21/21.
//

import UIKit
import Firebase


class LobbyViewController: UIViewController {

    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var bubbleZoom: UIImageView!
    
    var matches = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
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
        
        //zoom into a new bubble and transition into the matchingVC after 10 secs
        //change this to when a match is found later
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
        findMatches()
       
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
    
    
    func findMatches() {
        let ref = Database.database().reference().child("status")

        ref.observe(.childAdded, with: { snapshot in
            if let userDict = snapshot.value as? [String: Any] {
                let state = userDict["state"] as? String
                let uid = userDict["uid"] as? String
                self.matches[uid ?? ""] = state
            }
        })
     
      
       
        
    }
    

}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchUsername.text = nil
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))

        matchImage.addGestureRecognizer(imageTap)
        matchImage.isUserInteractionEnabled = true
        
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
            case .left:
                print("Swiped left")
            default:
                break
            }
        }
    }
    
    @objc func imageTapped() {
        print("image Tapped")
    }
    
}

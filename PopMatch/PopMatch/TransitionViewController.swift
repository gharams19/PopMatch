//
//  TransitionViewController.swift
//  PopMatch
//
//  Created by Eden Avivi on 2/26/21.
//

import UIKit

class TransitionViewController: UIViewController {

    @IBOutlet weak var matchingBubble: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        matchingBubble.isHidden = true
        matchingBubble.transform = CGAffineTransform.identity
        matchingBubble.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut , animations: {
            self.matchingBubble.isHidden = false
            self.matchingBubble.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
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

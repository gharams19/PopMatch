//
//  FriendViewController.swift
//  PopMatch
//
//  Created by Ma Eint Poe on 2/18/21.
//

import UIKit

class FriendViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .purple
    }

    @IBAction func toVideoCall(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let videoViewController = storyboard.instantiateViewController(withIdentifier: "videoVC") as? VideoViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        navigationController?.pushViewController(videoViewController, animated: true)
    }
    
}

//
//  MainViewController.swift
//  PopMatch
//
//  Created by Eden Avivi on 2/15/21.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

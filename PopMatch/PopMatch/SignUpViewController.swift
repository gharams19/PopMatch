//
//  SignUpViewController.swift
//  PopMatch
//
//  Created by Eden Avivi on 2/15/21.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var errLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        errLabel.text = nil
    }

    @IBAction func signUpButton() {
        //check if the email is correct and also have a check to verify the password
        //change back button to login viewController
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainVC") as? MainViewController else {
            assertionFailure("couldn't find vc") //will stop program
            return
        }
        //optional navigation controller
        navigationController?.pushViewController(mainViewController, animated: true)
    }
}

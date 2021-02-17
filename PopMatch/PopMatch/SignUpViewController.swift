//
//  SignUpViewController.swift
//  PopMatch
//
//  Created by Eden Avivi on 2/15/21.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var createPassTextField: UITextField!
    @IBOutlet weak var verifyPassTextField: UITextField!
    @IBOutlet weak var showHideCreate: UIButton!
    @IBOutlet weak var showHideVerify: UIButton!
    
    let showHideTitles: (String, String) = ("show", "hide")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errLabel.text = nil
        createPassTextField.isSecureTextEntry = true
        verifyPassTextField.isSecureTextEntry = true
        
    }
    
    func toggleButtonTitle(between titles:(String, String), on button: UIButton) -> Void {
        let newTitle = button.currentTitle == titles.0 ? titles.1 : titles.0
        button.setTitle(newTitle, for: .normal)
    }
    
    @IBAction func showCreatePass() {
        toggleButtonTitle(between: showHideTitles, on: showHideCreate)
        if showHideCreate.title(for: .normal) == "show" {
            createPassTextField.isSecureTextEntry = true
        } else if showHideCreate.title(for: .normal) == "hide" {
            createPassTextField.isSecureTextEntry = false
        }
    }
    
    @IBAction func showVerifyPass() {
        toggleButtonTitle(between: showHideTitles, on: showHideVerify)
        if showHideVerify.title(for: .normal) == "show" {
            verifyPassTextField.isSecureTextEntry = true
        } else if showHideVerify.title(for: .normal) == "hide" {
            verifyPassTextField.isSecureTextEntry = false
        }
    }

    @IBAction func logInHere() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let logInViewController = storyboard.instantiateViewController(withIdentifier: "logInVC") as? ViewController else {
            assertionFailure("couldn't find vc") //will stop program
            return
        }
        //optional navigation controller
        navigationController?.pushViewController(logInViewController, animated: true)
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

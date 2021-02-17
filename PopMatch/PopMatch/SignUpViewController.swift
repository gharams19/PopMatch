//
//  SignUpViewController.swift
//  PopMatch
//
//  Created by Eden Avivi on 2/15/21.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var errLabel: UILabel!
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var createPassTextField: UITextField!
    @IBOutlet weak var verifyPassTextField: UITextField!
    @IBOutlet weak var showHideCreate: UIButton!
    @IBOutlet weak var showHideVerify: UIButton!
    
    let showHideTitles: (String, String) = ("show", "hide")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errLabel.text = nil
        
        //password is automatically hidden
        createPassTextField.isSecureTextEntry = true
        verifyPassTextField.isSecureTextEntry = true
        
    }
    
    func toggleButtonTitle(between titles:(String, String), on button: UIButton) -> Void {
        
        //toggle between the two titles given
        let newTitle = button.currentTitle == titles.0 ? titles.1 : titles.0
        button.setTitle(newTitle, for: .normal)
    }
    
    @IBAction func showCreatePass() {
        
        //switch between two titles, show and hide
        toggleButtonTitle(between: showHideTitles, on: showHideCreate)
        if showHideCreate.title(for: .normal) == "show" {
            //show the password
            createPassTextField.isSecureTextEntry = true
        } else if showHideCreate.title(for: .normal) == "hide" {
            //hide the password
            createPassTextField.isSecureTextEntry = false
        }
    }
    
    @IBAction func showVerifyPass() {
        
        //switch between two titles, show and hide
        toggleButtonTitle(between: showHideTitles, on: showHideVerify)
        if showHideVerify.title(for: .normal) == "show" {
            //show the password
            verifyPassTextField.isSecureTextEntry = true
        } else if showHideVerify.title(for: .normal) == "hide" {
            //hide the password
            verifyPassTextField.isSecureTextEntry = false
        }
    }

    @IBAction func logInHere() {
        
        //Go into the log in viewcontroller, no checks needed
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let logInViewController = storyboard.instantiateViewController(withIdentifier: "logInVC") as? ViewController else {
            assertionFailure("couldn't find vc") //will stop program
            return
        }
        //optional navigation controller
        navigationController?.pushViewController(logInViewController, animated: true)
    }
    
    @IBAction func signUpButton() {
        //check if the email is correct
        
        if createPassTextField.text != verifyPassTextField.text {
            
            //if password fields do not match, present error
            errLabel.textColor = .red
            errLabel.text = "Password does not match"
        } else {
            //validate email
//            let emailString = emailTextField.text ?? nil
//            if !(emailString?.contains("@")){
//
//            }
            
            //check that all fields are full before proceeding
            if firstNameTextField.text == "" || lastNameTextField.text == "" || emailTextField.text == "" || createPassTextField.text == "" || verifyPassTextField.text == "" {
                errLabel.text = "Please fill all fields"
                errLabel.textColor = .red
            } else {
            
                //empty error
                errLabel.text = nil
            
                //go into next view controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainVC") as? MainViewController else {
                assertionFailure("couldn't find vc") //will stop program
                return
                }
                //optional navigation controller
                navigationController?.pushViewController(mainViewController, animated: true)
            }
        }
    }
}

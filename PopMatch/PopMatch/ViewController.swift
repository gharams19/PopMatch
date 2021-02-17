//
//  ViewController.swift
//  PopMatch
//
//  Created by Eden Avivi on 2/15/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showHideButton: UIButton!
    
    let showHideTitles: (String, String) = ("show", "hide")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errLabel.text = nil
        
        //password is automatically hidden
        passwordTextField.isSecureTextEntry = true
    }
    func toggleButtonTitle(between titles:(String, String), on button: UIButton) -> Void {
        
        //toggle between the two titles given
        let newTitle = button.currentTitle == titles.0 ? titles.1 : titles.0
        button.setTitle(newTitle, for: .normal)
    }
    
    @IBAction func showPassword() {
        
        //switch between two titles, show and hide
        toggleButtonTitle(between: showHideTitles, on: showHideButton)
        if showHideButton.title(for: .normal) == "show" {
            //show the password
            passwordTextField.isSecureTextEntry = true
        } else if showHideButton.title(for: .normal) == "hide" {
            //hide the password
            passwordTextField.isSecureTextEntry = false
        }
            
    }
    
    @IBAction func signUpHere() {
        
        //move to the signUpVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let signUpViewController = storyboard.instantiateViewController(withIdentifier: "signUpVC") as? SignUpViewController else {
            assertionFailure("couldn't find vc") //will stop program
            return
        }
        //optional navigation controller
        navigationController?.pushViewController(signUpViewController, animated: true)
        emailTextField.text = nil
        passwordTextField.text = nil
        self.view.endEditing(true)
    }
    
    @IBAction func logInButton() {
        
        //check if both fields are full
        if emailTextField.text == "" || passwordTextField.text == "" {
            errLabel.text = "Enter email and password"
            errLabel.textColor = .red
        } else {
            
            //check if the email and password match to an account in the database, if it matches (using Api call)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainVC") as? MainViewController else {
            assertionFailure("couldn't find vc") //will stop program
            return
            }
            //optional navigation controller
            navigationController?.pushViewController(mainViewController, animated: true)
        
            //clear textfields and dismiss keyboard
            emailTextField.text = nil
            passwordTextField.text = nil
            self.view.endEditing(true)
        
            //if it does not match, present error label on the type of error
            
        }
    }
    

}


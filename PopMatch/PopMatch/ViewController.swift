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
        passwordTextField.isSecureTextEntry = true
    }
    func toggleButtonTitle(between titles:(String, String), on button: UIButton) -> Void {
        let newTitle = button.currentTitle == titles.0 ? titles.1 : titles.0
        button.setTitle(newTitle, for: .normal)
    }
    
    @IBAction func showPassword() {
        toggleButtonTitle(between: showHideTitles, on: showHideButton)
        if showHideButton.title(for: .normal) == "show" {
            passwordTextField.isSecureTextEntry = true
        } else if showHideButton.title(for: .normal) == "hide" {
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
        //check if the email and password match to an account in the database, if it matches
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainVC") as? MainViewController else {
            assertionFailure("couldn't find vc") //will stop program
            return
        }
        //optional navigation controller
        navigationController?.pushViewController(mainViewController, animated: true)
        emailTextField.text = nil
        passwordTextField.text = nil
        self.view.endEditing(true)
        //if it does not match, present error label on the type of error 
    }
    

}


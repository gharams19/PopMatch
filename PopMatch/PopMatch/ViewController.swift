//
//  ViewController.swift
//  PopMatch
//
//  Created by Eden Avivi on 2/15/21.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showHideButton: UIButton!
    
    @IBOutlet weak var resetPasswordView: UIView!
    @IBOutlet weak var resetErrLabel: UILabel!
    @IBOutlet weak var resetPasswordEmail: UITextField!
    
    @IBOutlet weak var signUpHereButton: UIButton!
    @IBOutlet weak var logInOutlet: UIButton!
    @IBOutlet weak var resetOutlet: UIButton!
    
    @IBOutlet var tapGestureRecongizer: UITapGestureRecognizer!
    
    let showHideTitles: (String, String) = ("show", "hide")
    
    //handler for when the sign in state is changed
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errLabel.text = nil
        //password is automatically hidden
        passwordTextField.isSecureTextEntry = true
        
        //reset password custom pop up
        resetPasswordView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        resetPasswordView.sizeToFit()
        resetPasswordView.isHidden = true
        resetErrLabel.text = nil
       
        //set delegates for textfields
        emailTextField.delegate = self
        passwordTextField.delegate = self
        resetPasswordEmail.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //add a listener to the view controller which will get called when the sign in state is changed
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //detach the listener
        
        guard let handle1 = handle else {
            return
        }
        Auth.auth().removeStateDidChangeListener(handle1)
    }
    @IBAction func startEditing(_ sender: Any) {
        self.tapGestureRecongizer.isEnabled = true
    }
    
    
    @IBAction func tap(_ sender: Any) {
        self.view.endEditing(true)
        resetPasswordView.endEditing(true)
        self.tapGestureRecongizer.isEnabled = false
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
            
            Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] authResult, error in
                guard self != nil else { return }
                
                //if there is no error with signing in
                if error == nil {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let profileViewController = storyboard.instantiateViewController(withIdentifier: "profileVC") as? ProfileViewController else {
                            assertionFailure("couldn't find vc") //will stop program
                            return
                        }
                    //optional navigation controller
                    self?.navigationController?.pushViewController(profileViewController, animated: true)
            
                    //clear textfields and dismiss keyboard
                    self?.emailTextField.text = nil
                    self?.passwordTextField.text = nil
                    self?.view.endEditing(true)
                } else {
                    //present an error that could not sign in
                    self?.errLabel.text = "Invalid email or password"
                    self?.errLabel.textColor = .red
                }
            }
            
        }
    }
    
    @IBAction func resetPassword() {
        
        //add the custom popup
        resetPasswordView.isHidden = false
        resetPasswordView.layer.shadowColor = UIColor.black.cgColor
        resetPasswordView.layer.shadowOpacity = 0.3
        resetPasswordView.layer.shadowOffset = .zero
        resetPasswordView.layer.shadowRadius = 10
        resetPasswordView.backgroundColor = UIColor.white
        resetPasswordView.layer.cornerRadius = 25
        
        //diable background until done
        emailTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
        signUpHereButton.isUserInteractionEnabled = false
        logInOutlet.isUserInteractionEnabled = false
        resetOutlet.isUserInteractionEnabled = false
        
    }
    @IBAction func resetPassConfirm() {
        //send email to reset password
        Auth.auth().sendPasswordReset(withEmail: resetPasswordEmail.text ?? "", completion: { error in
            if error == nil {
                self.resetPasswordView.isHidden = true
                self.view.endEditing(true)
                self.emailTextField.isUserInteractionEnabled = true
                self.passwordTextField.isUserInteractionEnabled = true
                self.signUpHereButton.isUserInteractionEnabled = true
                self.logInOutlet.isUserInteractionEnabled = true
                self.resetOutlet.isUserInteractionEnabled = true
            } else {
                self.resetErrLabel.text = "Invalid email"
                self.resetErrLabel.textColor = .red
            }
        })
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}


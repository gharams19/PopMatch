//
//  SignUpViewController.swift
//  PopMatch
//
//  Created by Eden Avivi on 2/15/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errLabel: UILabel!
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var createPassTextField: UITextField!
    @IBOutlet weak var verifyPassTextField: UITextField!
    @IBOutlet weak var showHideCreate: UIButton!
    @IBOutlet weak var showHideVerify: UIButton!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    let showHideTitles: (String, String) = ("show", "hide")
    
    //handler for when the sign in state is changed
    var handle: AuthStateDidChangeListenerHandle?
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errLabel.text = nil
        
        //password is automatically hidden
        createPassTextField.isSecureTextEntry = true
        verifyPassTextField.isSecureTextEntry = true
        
        //set delegates for textfields
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        createPassTextField.delegate = self
        verifyPassTextField.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //add a listener to the view controller which will get called when the sign in state is changed
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //detach the listener
        //fix this forced unwrap
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func startEditing(_ sender: Any) {
        self.tapGestureRecognizer.isEnabled = true
    }
    
    @IBAction func tap(_ sender: Any) {
        self.view.endEditing(true)
        self.tapGestureRecognizer.isEnabled = false
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
        
        //if password fields do not match, present error
        if createPassTextField.text != verifyPassTextField.text {
            errLabel.textColor = .red
            errLabel.text = "Password does not match"
        } else {
            
            //check that all fields are full before proceeding
            if firstNameTextField.text == "" || lastNameTextField.text == "" || emailTextField.text == "" || createPassTextField.text == "" || verifyPassTextField.text == "" {
                errLabel.text = "Please fill all fields"
                errLabel.textColor = .red
            } else {
                Auth.auth().createUser(withEmail: emailTextField.text ?? "", password: createPassTextField.text ?? "", completion: { authResult, error in
                    
                    //if there is no error with creating a user
                    if error == nil {
                        //empty error
                        self.errLabel.text = nil
                        var ref: DocumentReference? = nil
                        ref = self.db.collection("users").addDocument(data: [
                            "first name": self.firstNameTextField.text,
                            "last name": self.lastNameTextField.text,
                            "username": "",
                            "email": self.emailTextField.text
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added with ID: \(ref?.documentID)")
                            }
                        }

                        //go into next view controller
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        guard let profileViewController = storyboard.instantiateViewController(withIdentifier: "profileVC") as? ProfileViewController else {
                                assertionFailure("couldn't find vc") //will stop program
                                return
                            }
                        //optional navigation controller
                        self.navigationController?.pushViewController(profileViewController, animated: true)
                    } else {
                        
                        //present error, that could not create an account
                        print(error)
                        self.errLabel.text = "Could not create account"
                        self.errLabel.textColor = .red
                    }
                })
                
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

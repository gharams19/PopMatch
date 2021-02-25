//
//  ProfileViewController.swift
//  PopMatch
//
//  Created by Ma Eint Poe on 2/21/21.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate {

  
    @IBOutlet weak var profileImage: UIImageView!
    
    // TextFields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    // Social Media
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var snapchatBtn: UIButton!
    @IBOutlet weak var instagramBtn: UIButton!
    @IBOutlet weak var linkedinBtn: UIButton!
    
    var twitterLink = ""
    var facebookLink = ""
    var snapchatLink = ""
    var instagramLink = ""
    var linkedinLink = ""
    
    @IBOutlet weak var signoutBtn: UIButton!
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Styling
        signoutBtn.layer.cornerRadius = 15
        bottomBorder(usernameTextField)
        bottomBorder(firstnameTextField)
        bottomBorder(lastnameTextField)
        bottomBorder(emailTextField)
        bottomBorder(passwordTextField)
        
        // Delegate TextFields
        usernameTextField.delegate = self
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
        emailTextField.delegate = self

        
        // Display the stored data of user if it exists
        displayUserData()
        
    }
    
    // Styling
    func bottomBorder(_ textField: UITextField) {
        let layer = CALayer()
        layer.backgroundColor = UIColor.blue.cgColor
        layer.frame = CGRect(x: 0.0, y: textField.frame.size.height - 1.0, width: textField.frame.size.width, height: 1.0)
        textField.layer.addSublayer(layer)
    }
    
    
    
    //
    func displayUserData () {
        let userData = db.collection("users").document("testing-user-profile")
        userData.getDocument { (document, error) in
            
            if let document = document, document.exists {
                self.usernameTextField.text = document.get("username") as? String ?? ""
                
                if let firstname = document.get("first name") {
                    self.firstnameTextField.text = firstname as? String
                }
                
                if let lastname = document.get("last name") {
                    self.lastnameTextField.text = lastname as? String
                }
                
                if let email = document.get("email") {
                    self.emailTextField.text = email as? String
                }
            } else {
                print("User document doesn't exists")
            }
            
            // Set the social media links
            let userSocialData = userData.collection("socials").document("links")
            userSocialData.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let twitter = document.get("twitter") {
                        self.twitterLink = twitter as? String ?? ""
                        print("twitterLink: \(self.twitterLink)")
                    }
                    if let facebook = document.get("facebook") {
                        self.facebookLink = facebook as? String ?? ""
                    }
                    if let snapchat = document.get("snapchat") {
                        self.snapchatLink = snapchat as? String ?? ""
                    }
                    if let instagram = document.get("instagram") {
                        self.instagramLink = instagram as? String ?? ""
                    }
                    if let linkedin = document.get("linkedin") {
                        self.linkedinLink = linkedin as? String ?? ""
                    }
                } else {
                    print("Social Media link doc doesn't exists")
                }
            }
            
            
        }
    }
 
    @IBAction func to_lobby(_ sender: Any) {
        // go to lobby view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let lobbyViewController = storyboard.instantiateViewController(identifier: "lobbyVC") as? LobbyViewController else {
            assertionFailure("couldn't find vc")
            return }
        //optional navigation controller
        navigationController?.pushViewController(lobbyViewController, animated: true)
    }

    @IBAction func toEditFriend() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let friendViewController = storyboard.instantiateViewController(identifier: "friendVC") as? FriendViewController else {
            assertionFailure("couldn't find vc")
            return }
        //optional navigation controller
        navigationController?.pushViewController(friendViewController, animated: true)
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        
        guard let range = Range(range, in: currentText) else { assertionFailure("range not defined")
            return true
        }
        
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        textField.text = newText
        
        // Store the new change into the api
        
        print("newText: \(newText)")
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print("textFieldShouldReturn called")
        
        // Maybe switch to using a map instead?
        switch textField {
        case usernameTextField:
            usernameTextField.resignFirstResponder()
        case firstnameTextField:
            firstnameTextField.resignFirstResponder()
        case lastnameTextField:
            lastnameTextField.resignFirstResponder()
        case emailTextField:
            emailTextField.resignFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            usernameTextField.resignFirstResponder()
        }
        
        // Make the api request here to send the data to db
        let sendData = ["username" : usernameTextField.text, "first name" : firstnameTextField.text, "last name" : lastnameTextField.text, "email" : emailTextField.text]
        let newDoc = db.collection("users").document("testing-user-profile")
        newDoc.setData(sendData as [String : Any])
        print("db sent?")
        return true
    }
    
    
    
    
    @IBAction func twitterClicked() {
        // call twitter pop
    }
    
    
    @IBAction func facebookClicked() {
    }
    
    
    @IBAction func snapchatClicked() {
    }
    
    @IBAction func instagramClicked() {
    }
    
    @IBAction func linkedinClicked() {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

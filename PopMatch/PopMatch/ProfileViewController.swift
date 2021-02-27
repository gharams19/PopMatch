//
//  ProfileViewController.swift
//  PopMatch
//
//  Created by Ma Eint Poe on 2/21/21.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate {
    var docID: String = ""
    
    @IBOutlet weak var settingBtn: UIButton!
    
    @IBOutlet weak var signoutBtn: UIButton!
    @IBOutlet weak var lobbyBtn: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var resetBtn: UIButton!
    
    
    // TextFields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var TFFields: [UITextField] = []
   
    // Social Media
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var snapchatBtn: UIButton!
    @IBOutlet weak var instagramBtn: UIButton!
    @IBOutlet weak var linkedinBtn: UIButton!
    
    // Pop Up View
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var closeViewBtn: UIButton!
    @IBOutlet weak var popUpLabel: UILabel!
    @IBOutlet weak var popUpTextField: UITextField!
    @IBOutlet weak var popUpErrLabel: UILabel!
    @IBOutlet weak var popUpConfirmBtn: UIButton!
    
    var twitterLink = ""  // 1
    var facebookLink = ""  // 2
    var snapchatLink = ""  // 3
    var instagramLink = ""  // 4
    var linkedinLink = ""  // 5
    
    var links: [String] = []
    
   
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleSetUp()
        
        self.TFFields = [usernameTextField, firstnameTextField, lastnameTextField, emailTextField, popUpTextField]
        self.TFFields = self.TFFields.map({$0.delegate = self; return $0})
        
        self.links = [twitterLink, facebookLink, snapchatLink, instagramLink, snapchatLink]

        popUpView.isHidden = true
        popUpConfirmBtn.isHidden = true
        popUpErrLabel.isHidden = true
        
        // Display the stored data of user if it exists
        displayUserData()
        
    }
    
    // MARK: - Styling
    func styleSetUp() {
        signoutBtn.layer.cornerRadius = 15
        popUpView.layer.cornerRadius = 15
        popUpView.layer.borderWidth = 1.5
        popUpView.layer.borderColor = UIColor.systemOrange.cgColor
        popUpConfirmBtn.layer.borderWidth = 1
        popUpConfirmBtn.layer.borderColor = UIColor.systemOrange.cgColor
        popUpConfirmBtn.layer.cornerRadius = 15
        bottomBorder(usernameTextField)
        bottomBorder(firstnameTextField)
        bottomBorder(lastnameTextField)
        bottomBorder(emailTextField)
        bottomBorder(popUpTextField)
    }
    
    // Styling - textfield
    func bottomBorder(_ textField: UITextField) {
        let layer = CALayer()
        layer.backgroundColor = UIColor.blue.cgColor
        layer.frame = CGRect(x: 0.0, y: textField.frame.size.height - 1.0, width: textField.frame.size.width, height: 1.0)
        textField.layer.addSublayer(layer)
    }
    
    
    // MARK: - Display User Data
    // Make API call to database and display data
    func displayUserData () {
        print("displayUserData called")
        let userData = db.collection("users").document("testing-user-profile")
        userData.getDocument { (document, error) in
            if error == nil {
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
            } else {
                print ("Error in user document, error: \(String(describing: error))")
            }
        }
            
        // Set the social media links
        let userSocialData = userData.collection("socials").document("links")
        userSocialData.getDocument { (document, error) in
            if error == nil {
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
            } else {
                print("Error in getting social document, error: \(String(describing: error))")
            }
        }
    }
    
  
    // MARK: - Handling Textfield changes
    
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
        case popUpTextField:
            popUpTextField.resignFirstResponder()
        default:
            usernameTextField.resignFirstResponder()
        }
        
        // Update the appropriate social media links
        if textField == popUpTextField {

            switch popUpLabel.text {
            case "Twitter":
                self.twitterLink = popUpTextField.text ?? ""
            case "Facebook":
                self.facebookLink = popUpTextField.text ?? ""
            case "Snapchat":
                self.snapchatLink = popUpTextField.text ?? ""
            case "Instagram":
                self.instagramLink = popUpTextField.text ?? ""
            case "LinkedIn":
                self.linkedinLink = popUpTextField.text ?? ""
            default:
                print("Doesn't match any of the social media, meaning it's for password reset")
            }
            
        } else {
            storeData()
        }

        
        return true
    }
    
    
    // MARK: - Social Media Button Clicked
    @IBAction func twitterClicked() {
        displayPopUp("Twitter", twitterLink, false);
    }
    
    @IBAction func facebookClicked() {
        displayPopUp("Facebook", facebookLink, false)
    }
    
    @IBAction func snapchatClicked() {
        displayPopUp("Snapchat", snapchatLink, false)
    }
    
    @IBAction func instagramClicked() {
        displayPopUp("Instagram", instagramLink, false)
    }
    
    @IBAction func linkedinClicked() {
        displayPopUp("LinkedIn", linkedinLink, false)
    }
    
    
    // MARK: - Pop up for Social Media & Reset Password
    // Display pop up view
    func displayPopUp(_ label: String, _ text: String, _ reset: Bool) {
        // Disable all the other functions
        usernameTextField.isUserInteractionEnabled = false
        firstnameTextField.isUserInteractionEnabled = false
        lastnameTextField.isUserInteractionEnabled = false
        resetBtn.isUserInteractionEnabled = false
        signoutBtn.isUserInteractionEnabled = false
        settingBtn.isUserInteractionEnabled = false
        lobbyBtn.isUserInteractionEnabled = false
        twitterBtn.isUserInteractionEnabled = false
        facebookBtn.isUserInteractionEnabled = false
        snapchatBtn.isUserInteractionEnabled = false
        instagramBtn.isUserInteractionEnabled = false
        linkedinBtn.isUserInteractionEnabled = false
        
        if reset {
            popUpLabel.font = popUpLabel.font.withSize(16)
            popUpConfirmBtn.isHidden = false
            popUpConfirmBtn.isUserInteractionEnabled = true
        } else {
            popUpLabel.font.withSize(22)
        }
        
        
        popUpView.isHidden = false
        popUpLabel.text = label
        popUpTextField.text = text

    }
    
    
    @IBAction func closePopUp() {
        print("closePopUp called")
        // Clean up this code later
        popUpView.isHidden = true
        usernameTextField.isUserInteractionEnabled = true
        firstnameTextField.isUserInteractionEnabled = true
        lastnameTextField.isUserInteractionEnabled = true
        resetBtn.isUserInteractionEnabled = true
        settingBtn.isUserInteractionEnabled = true
        signoutBtn.isUserInteractionEnabled = true
        lobbyBtn.isUserInteractionEnabled = true
        twitterBtn.isUserInteractionEnabled = true
        facebookBtn.isUserInteractionEnabled = true
        snapchatBtn.isUserInteractionEnabled = true
        instagramBtn.isUserInteractionEnabled = true
        linkedinBtn.isUserInteractionEnabled = true
        
        popUpConfirmBtn.isHidden = true
        popUpConfirmBtn.isUserInteractionEnabled = false
        popUpErrLabel.isHidden = true
        popUpTextField.text = ""
        
        storeData()

    }
    
    
    
    // MARK: - Updating the database
    func storeData() {
        
        // Make the request to store the data
        let userData = ["username" : usernameTextField.text, "first name" : firstnameTextField.text, "last name" : lastnameTextField.text, "email" : emailTextField.text]
        let userDoc = db.collection("users").document("testing-user-profile")
        userDoc.updateData(userData as [String : Any])
        
        
        let socialData = ["twitter" : twitterLink, "facebook" : facebookLink, "snapchat" : snapchatLink, "instagram" : instagramLink, "linkedin" : linkedinLink]
        let socialDoc = userDoc.collection("socials").document("links")
        socialDoc.updateData(socialData)
    
        // keep the user data updated the new
        displayUserData()
    }
    
    
    // MARK: - Reseting Password
    // Reset button pressed
    @IBAction func resetPassPress() {
        displayPopUp("Enter the email to send the reset link", "", true)
    }
    
    // Reset password confirm
    @IBAction func confirmReset(_ sender: Any) {
        
        // Send email to reset password
        Auth.auth().sendPasswordReset(withEmail: popUpTextField.text ?? "",  completion: { error in
            if error == nil {
                self.closePopUp()
            } else {
                self.popUpErrLabel.isHidden = false
                self.popUpErrLabel.text = "Invalid email"
            }
        })
    }
    
    
    // MARK: - Navigation
    @IBAction func to_lobby(_ sender: Any) {
        // go to lobby view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let lobbyViewController = storyboard.instantiateViewController(identifier: "lobbyVC") as? LobbyViewController else {
            assertionFailure("couldn't find vc")
            return }
        //optional navigation controller
        navigationController?.pushViewController(lobbyViewController, animated: true)
    }

    // Setting button pressed
    @IBAction func toEditFriend() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let friendViewController = storyboard.instantiateViewController(identifier: "friendVC") as? FriendViewController else {
            assertionFailure("couldn't find vc")
            return }
        //optional navigation controller
        navigationController?.viewControllers = [friendViewController]
        
        
    }
    
    // Sign out button pressed
    @IBAction func toLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginViewController = storyboard.instantiateViewController(identifier: "logInVC") as? ViewController else {
            assertionFailure("couldn't find vc")
            return }
        //optional navigation controller
        navigationController?.pushViewController(loginViewController, animated: true)
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

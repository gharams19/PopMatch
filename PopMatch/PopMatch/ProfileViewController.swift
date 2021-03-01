//
//  ProfileViewController.swift
//  PopMatch
//
//  Created by Ma Eint Poe on 2/21/21.
//

import UIKit
import Photos
import Firebase
import FirebaseStorage
import FirebaseUI


class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var docID: String = ""
    
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var signoutBtn: UIButton!
    @IBOutlet weak var lobbyBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
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
    var buttons: [UIButton] = []
    
    // Pop Up View
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var closeViewBtn: UIButton!
    @IBOutlet weak var popUpLabel: UILabel!
    @IBOutlet weak var popUpTextField: UITextField!
    @IBOutlet weak var popUpErrLabel: UILabel!
    @IBOutlet weak var popUpConfirmBtn: UIButton!
    
    var twitterLink: String = ""
    var facebookLink: String = ""
    var snapchatLink: String = ""
    var instagramLink: String = ""
    var linkedinLink: String = ""
    
    var links: [String] = []
    
    var imageURL: URL?
    var imageText: String = ""
   
    var db = Firestore.firestore()
    var storage = Storage.storage()
    
    var imagePickerController = UIImagePickerController()
    let placeholderImage = UIImage(systemName: "person")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleSetUp()
        
        // Set Arrays & Delegates
        self.TFFields = [usernameTextField, firstnameTextField, lastnameTextField, emailTextField, popUpTextField]
        self.links = [twitterLink, facebookLink, snapchatLink, instagramLink, snapchatLink]
        self.buttons = [twitterBtn, facebookBtn, snapchatBtn, instagramBtn, linkedinBtn, signoutBtn, resetBtn, settingBtn, popUpConfirmBtn, closeViewBtn, profileBtn, lobbyBtn]
        self.TFFields = self.TFFields.map({$0.delegate = self; return $0})
        self.imagePickerController.delegate = self
        
        // Hide pop until button press
        popUpView.isHidden = true
        popUpConfirmBtn.isHidden = true
        popUpErrLabel.isHidden = true
        
        // Display the stored data
        displayUserData()
        
        buildPresence()
        
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
       // print("displayUserData called")
        let userData = db.collection("users").document(docID)
        userData.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    self.usernameTextField.text = document.get("username") as? String ?? ""
                    
                    if let image = document.get("image") {
                        self.imageText = image as? String ?? ""
                        self.profileImage.sd_setImage(with: URL(string: self.imageText), placeholderImage: self.placeholderImage)
                       // self.profileImage.sizeToFit()
                        self.profileImage.contentMode = .scaleAspectFill
                    }
                    
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
                    print("Social Media link doc doesn't exists, user hasn't inputted any")
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
        
        textField.text = currentText.replacingCharacters(in: range, with: string)
    
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //    print("textFieldShouldReturn called")

        textField.resignFirstResponder()
        
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
            // Store data right away if it's not the pop because pop would've stored already
            storeData()
        }

        return true
    }
    
    // MARK: - Profile Picture Related
    @IBAction func addProfileImage() {
     //   print("addProfileImage called")
        checkPermission()
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
        
    }
    
    func checkPermission() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({
                (status: PHAuthorizationStatus) -> Void in ()
            })
        }
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {} else {
            PHPhotoLibrary.requestAuthorization(requestAuthorization)
        }
    }
    
    func requestAuthorization(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("Have access to photos")
        } else {
            print("Don't have access to photos")
        }
    }
    
    // Get the url of selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            uploadToStorage(fileURL: url)
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func uploadToStorage(fileURL: URL) {
        let _ = Data()
        let storageRef = storage.reference()
        
        let localFile = fileURL
        
        let photoRef = storageRef.child(docID)
        let _ = photoRef.putFile(from: localFile, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            }
        
        // Photo downloaded, store the url to user data in db
        photoRef.downloadURL(completion: { (url, error) in
            if let urlText = url?.absoluteString {
                self.imageText = urlText
               // print("Image url in db: \(urlText)")
                self.storeData()
            }
        })
        print("Photo has been uploaded to storage")
        }
        profileImage.sd_setImage(with: photoRef, placeholderImage: placeholderImage)
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
        // Disable all the background functions
        TFFields = TFFields.map({ $0.isUserInteractionEnabled = false; return $0})
        buttons = buttons.map({ $0.isUserInteractionEnabled = false; return $0})
        
        popUpTextField.isUserInteractionEnabled = true
        closeViewBtn.isUserInteractionEnabled = true
        
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
      //  print("closePopUp called")
        // Clean up this code later
        popUpView.isHidden = true
        popUpConfirmBtn.isHidden = true
        popUpErrLabel.isHidden = true
        
        TFFields = TFFields.map({ $0.isUserInteractionEnabled = true; return $0})
        buttons = buttons.map({ $0.isUserInteractionEnabled = true; return $0})
        
        popUpConfirmBtn.isHidden = true
        popUpConfirmBtn.isUserInteractionEnabled = false
        popUpTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
        
        popUpTextField.text = ""
        
        storeData()
    }
    
    
    
    // MARK: - Updating the database
    func storeData() {
        
        // Make the request to store the data
        
        // User Data
        let userDoc = db.collection("users").document(docID)
        userDoc.updateData([
            "username": usernameTextField.text ?? (Any).self,
            "image": imageText,
            "first name": firstnameTextField.text ?? (Any).self,
            "last name": lastnameTextField.text ?? (Any).self,
            "email" : emailTextField.text ?? (Any).self,
        ])
        
        // Social Media links
        let socialData = ["twitter" : twitterLink, "facebook" : facebookLink, "snapchat" : snapchatLink, "instagram" : instagramLink, "linkedin" : linkedinLink]
        let socialDoc = userDoc.collection("socials").document("links")
        socialDoc.setData(socialData)
    
        // keep the user data updated with new info
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
        navigationController?.pushViewController(friendViewController, animated: true)
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
    func buildPresence() {
        //MARK: Build Presence System
         
         /*Set up presence with realtime database*/
         
         // Fetch the current user's ID from Firebase Authentication.
         
         let uid = Firebase.Auth.auth().currentUser?.uid
         
         let path = "/status/" + String(uid ?? "")
         
         
         // Create a reference to this user's specific status node.
         // This is where we will store data about being online/offline.
         let userStatusDatabaseRef = FirebaseDatabase.Database.database().reference(withPath: path)
         
         // We'll create two constants which we will write to
         // the Realtime database when this device is offline
         // or online.
         var isOffline: [String: Any] = [
            "uid": uid ?? "",
             "state": "offline",
         ]
         var isOnline: [String: Any] = [
            "uid": uid ?? "",
             "state": "online",
         ]
         
         // Create a reference to the special '.info/connected' path in
         // Realtime Database. This path returns `true` when connected
         // and `false` when disconnected.
         let connectedRef = Database.database().reference(withPath: ".info/connected")
         connectedRef.observeSingleEvent(of: .value, with: { snapshot in
             if((snapshot.value != nil) == false) {
                 
                 return
             }
             
         })
         
         // If we are currently connected, then use the 'onDisconnect()'
             // method to add a set which will only trigger once this
             // client has disconnected by closing the app,
             // losing internet, or any other means.
         userStatusDatabaseRef.onDisconnectSetValue(isOffline, withCompletionBlock: {_,_ in
             userStatusDatabaseRef.setValue(isOnline)
             
             
         })
       
    }
}

//
//  ProfileViewController.swift
//  PopMatch
//
//  Created by Ma Eint Poe on 2/21/21.
//

import UIKit

class ProfileViewController: UIViewController {

  
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
    
    @IBOutlet weak var signoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Styling
        signoutBtn.layer.cornerRadius = 15
        bottomBorder(usernameTextField)
        bottomBorder(firstnameTextField)
        bottomBorder(lastnameTextField)
        bottomBorder(emailTextField)
        
    }
    
    func bottomBorder(_ textField: UITextField) {
        let layer = CALayer()
        layer.backgroundColor = UIColor.blue.cgColor
        layer.frame = CGRect(x: 0.0, y: textField.frame.size.height - 1.0, width: textField.frame.size.width, height: 1.0)
        textField.layer.addSublayer(layer)
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

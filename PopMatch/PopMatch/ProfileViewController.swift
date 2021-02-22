//
//  ProfileViewController.swift
//  PopMatch
//
//  Created by Ma Eint Poe on 2/21/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileSignOutBtn: UIButton!
    
    // Textfields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!  // <-- UNSURE ABOUT THIS
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Styling
        profileSignOutBtn.layer.cornerRadius = 15
        bottomBorder(textField: usernameTextField)
        bottomBorder(textField: firstnameTextField)
        bottomBorder(textField: lastnameTextField)
        bottomBorder(textField: emailTextField)
   

        
    }
    
    func bottomBorder(textField: UITextField) {
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

    @IBAction func toEditQuestion(_ sender: Any) {
        
        //go into edit question view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editQuestionViewController = storyboard.instantiateViewController(identifier: "editQuestionVC") as? EditQuestionViewController else {
            assertionFailure("couldn't find vc")
            return }
        //optional navigation controller
        navigationController?.pushViewController(editQuestionViewController, animated: true)
        
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

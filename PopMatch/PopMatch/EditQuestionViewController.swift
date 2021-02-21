//
//  EditQuestionViewController.swift
//  PopMatch
//
//  Created by Ma Eint Poe on 2/21/21.
//

import UIKit

class EditQuestionViewController: UIViewController {

    @IBOutlet weak var editDoneBtn: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        editDoneBtn.layer.cornerRadius = 15
    }
    
    @IBAction func leftSwipe(_ sender: Any) {
        print("left swiped")
        //go into friend view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let friendViewController = storyboard.instantiateViewController(identifier: "friendVC") as? FriendViewController else {
            assertionFailure("couldn't find vc")
            return }
        //optional navigation controller
        navigationController?.pushViewController(friendViewController, animated: true)
    }
    
    
    // Make the animation come from the leftside instead of default right
    @IBAction func rightSwipe(_ sender: Any) {
        print("right swiped")
        //go into professional view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let professionalViewController = storyboard.instantiateViewController(identifier: "professionalVC") as? ProfessionalViewController else {
            assertionFailure("couldn't find vc")
            return }
        //optional navigation controller
        navigationController?.pushViewController(professionalViewController, animated: true)
    }
    
    @IBAction func toProfile(_ sender: Any) {
        //go into profile view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let profileViewController = storyboard.instantiateViewController(identifier: "profileVC") as? ProfileViewController else {
            assertionFailure("couldn't find vc")
            return }
        //optional navigation controller
        navigationController?.viewControllers = [profileViewController]
    }
    

}

//
//  ProfileViewController.swift
//  PopMatch
//
//  Created by Ma Eint Poe on 2/21/21.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

//
//  ViewController.swift
//  VideoQuickStart
//
//  Copyright © 2016-2019 Twilio, Inc. All rights reserved.
//

import UIKit

import TwilioVideo

class VideoViewController: UIViewController {

 
  

    
    // Video SDK components
    
    
    // MARK:- UI Element Outlets and handles
    
    // `VideoView` created from a storyboard
//    @IBOutlet weak var previewView: VideoView!

    @IBOutlet weak var connectButton: UIButton!
    
    
    @IBOutlet weak var roomTextField: UITextField!
    @IBOutlet weak var roomLine: UIView!
    @IBOutlet weak var roomLabel: UILabel!
    
    
   

    // MARK:- UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "QuickStart"
    
        self.roomTextField.autocapitalizationType = .none
       

    }

    @IBAction func connect(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let meetingViewController = storyboard.instantiateViewController(withIdentifier: "meetingVC") as? MeetingViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        meetingViewController.accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTS2ZhY2FjOGE3OTRlNzM4MWZiNWZmODJjZGI3NzBmYmY2LTE2MTM5NDAwNjQiLCJpc3MiOiJTS2ZhY2FjOGE3OTRlNzM4MWZiNWZmODJjZGI3NzBmYmY2Iiwic3ViIjoiQUNjNmNjYWIzMjZkZTVlMDA0Y2U4OWNjYTA0MTA1MDljNSIsImV4cCI6MTYxMzk0MzY2NCwiZ3JhbnRzIjp7ImlkZW50aXR5IjoiUGVyc29uIDIiLCJ2aWRlbyI6eyJyb29tIjoicG9wbWF0Y2gifX19.26qBdvdwHYeMQtT2_xrv23oWf0Sxb8B7v3t9JWOGukU"
        navigationController?.pushViewController(meetingViewController, animated: true)
        
    }
    
    
 

    
}



//// MARK:- UITextFieldDelegate
//extension VideoViewController : UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.connect(sender: textField)
//        return true
//    }
//}

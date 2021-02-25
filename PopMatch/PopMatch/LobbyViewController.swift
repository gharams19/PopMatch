//
//  lobbyViewController.swift
//  PopMatch
//
//  Created by Ray Ngan on 2/21/21.
//

import UIKit

class LobbyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func match_accepted(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let meetingViewController = storyboard.instantiateViewController(withIdentifier: "meetingVC") as? MeetingViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        // need to gernerate tokens for each user
        meetingViewController.accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTS2ZhY2FjOGE3OTRlNzM4MWZiNWZmODJjZGI3NzBmYmY2LTE2MTM5NDAwNjQiLCJpc3MiOiJTS2ZhY2FjOGE3OTRlNzM4MWZiNWZmODJjZGI3NzBmYmY2Iiwic3ViIjoiQUNjNmNjYWIzMjZkZTVlMDA0Y2U4OWNjYTA0MTA1MDljNSIsImV4cCI6MTYxMzk0MzY2NCwiZ3JhbnRzIjp7ImlkZW50aXR5IjoiUGVyc29uIDIiLCJ2aWRlbyI6eyJyb29tIjoicG9wbWF0Y2gifX19.26qBdvdwHYeMQtT2_xrv23oWf0Sxb8B7v3t9JWOGukU"
        navigationController?.pushViewController(meetingViewController, animated: true)
        
    }
    

}

//
//  lobbyViewController.swift
//  PopMatch
//
//  Created by Ray Ngan on 2/21/21.
//

import UIKit

class LobbyViewController: UIViewController {
    var username = "RayNgan"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func match_accepted(_ sender: Any) {
        let userToken = self.getToken()
        print(userToken)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let meetingViewController = storyboard.instantiateViewController(withIdentifier: "meetingVC") as? MeetingViewController else {
            assertionFailure("couldn't find vc")
            return
        }
        // need to gernerate tokens for each user
        meetingViewController.accessToken = userToken
        meetingViewController.roomName = "PopRoom"
        navigationController?.pushViewController(meetingViewController, animated: true)
        
    }
    
    func getToken() ->String{
        var tokenURL = "https://glaucous-centipede-6895.twil.io/video-token?identity="
        tokenURL.append(username)
        var accessToken = ""
        do {
            accessToken = try fetchToken(url: tokenURL)
        } catch {
            print("Failed to fetch access token")
            return ""
        }
        accessToken = String(accessToken.dropFirst(10))
        return accessToken
    }
    
    func fetchToken(url : String) throws -> String {
            var token: String = "TWILIO_ACCESS_TOKEN"
            let requestURL: URL = URL(string: url)!
            do {
                let data = try Data(contentsOf: requestURL)
                if let tokenReponse = String(data: data, encoding: String.Encoding.utf8) {
                    token = tokenReponse
                }
            } catch let error as NSError {
                print ("Invalid token url, error = \(error)")
                throw error
            }
            return token
    }


}



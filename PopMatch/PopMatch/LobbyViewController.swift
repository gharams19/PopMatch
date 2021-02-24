//
//  lobbyViewController.swift
//  PopMatch
//
//  Created by Ray Ngan on 2/21/21.
//

import UIKit

class LobbyViewController: UIViewController {
    @IBOutlet weak var bubbleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bubbleView.backgroundColor = .white
        self.view.addSubview(bubbleView)
        var array: [UIImageView] = []
        let userNumber = 10
        for _ in 0...userNumber-1 {
            let bubbleImageView = UIImageView(image: #imageLiteral(resourceName: "bubble2 copy"))
            bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
            array.append(bubbleImageView)
        }
        for i in 0...userNumber-1 {
            bubbleView.addSubview(array[i])
            array[i].center.x = bubbleView.center.x
            array[i].center.y = bubbleView.center.y
            animation(image: array[i])
        }
        
        
    }
    func animation(image: UIImageView) {
        let maxX = self.bubbleView.frame.maxX - CGFloat(100)
        let maxY = self.bubbleView.frame.height - CGFloat(100)
        var newX = UInt32(0)
        var newY = UInt32(0)
        
        //decide randomly which direction to go into
        let sideDecider = Int.random(in: 1...4)
        switch sideDecider {
        case 1:
            newX = UInt32(maxX)
            newY = 0
        case 2:
            newX = UInt32(maxX)
            newY = UInt32(maxY)
        case 3:
            newX = 0
            newY = UInt32(maxY)
        case 4:
            newX = 0
            newY = 0
        default:
            newX = 0
            newY = 0
        }
        
        //calculation of distance to have the speed of the bubble be constant
        var distanceX = UInt32(0)
        var distanceY = UInt32(0)
        if newX > UInt32(image.center.x) {
            distanceX = newX - UInt32(image.center.x)
        } else {
            distanceX = UInt32(image.center.x) - newX
        }
        if newY > UInt32(image.center.y) {
            distanceY = newY - UInt32(image.center.y)
        } else {
            distanceY = UInt32(image.center.y) - newY
        }
    
        let totalDistance = sqrt(Double(distanceX * distanceX)) + sqrt(Double(distanceY * distanceY))
        let velocity = 125
        UIView.animate(withDuration: totalDistance / Double(velocity), delay: 0, options: .curveLinear, animations: {
            image.frame.origin.x = CGFloat(newX)
            image.frame.origin.y = CGFloat(newY)
            image.layoutIfNeeded()
        }, completion:
        { finished in
            self.animation(image: image)
        }
        )
    }
    
    func distance() {
        
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

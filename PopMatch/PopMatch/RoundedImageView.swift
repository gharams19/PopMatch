//
//  RoundedImageView.swift
//  PopMatch
//
//  Created by Gharam Alsaedi on 2/23/21.
//

import UIKit

@IBDesignable public class RoundedImageView: UIImageView {

    override public func layoutSubviews() {
            super.layoutSubviews()
        
            // Make Image Round
            layer.cornerRadius = 0.5 * bounds.size.width
        
        //if user has profile pic add border
       
            layer.borderWidth = 8.0
        
            layer.borderColor = UIColor(displayP3Red: 0.91, green: 0.87, blue: 1.0, alpha: 1.0).cgColor
        }
        
        

}

//
//  Interface.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 12/19/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView


func cornerRatio(view : UIView, ratio : CGFloat, masksToBounds : Bool){
    view.layer.cornerRadius = ratio
    
    view.layer.masksToBounds = true
    if masksToBounds{
        view.layer.masksToBounds = false
    }
}

func fadeView(view : UIView, delay: TimeInterval, isHiden: Bool) {
    
    let animationDuration = 0.25
    
    // Fade in the view
    UIView.animate(withDuration: animationDuration, animations: { () -> Void in
        //        view.alpha = 1
    }) { (Bool) -> Void in
        
        // After the animation completes, fade out the view after a delay
        
        UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseOut, animations: { () -> Void in
            if isHiden{
                view.alpha = 0
            } else {
                view.alpha = 1
            }
        },
                       completion: nil)
    }
}

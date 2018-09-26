//
//  TFWitoutCursor.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 16.09.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class TFWitoutCursor: UITextField {

    override func caretRect(for position: UITextPosition) -> CGRect {
    return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [Any] {
    return []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    
    if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
    
    return false
    }
    
    return super.canPerformAction(action, withSender: sender)
    }

}

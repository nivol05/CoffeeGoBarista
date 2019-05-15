//
//  EndOfShiftVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/26/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class EndOfShiftVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var collectionTF: UITextField!
    @IBOutlet weak var salaryTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        salaryTF.delegate = self
        collectionTF.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        let text = textField.text != nil ? textField.text! : ""
        let newLength = text.count + string.count - range.length
        
        return string == numberFiltered && newLength <= 6
    }

    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func salaryTF(_ sender: Any) {
    }
    
    @IBAction func collectionTF(_ sender: Any) {
    }
    

}

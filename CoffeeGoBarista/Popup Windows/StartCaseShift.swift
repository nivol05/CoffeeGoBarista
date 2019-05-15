//
//  StartCaseShift.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 5/3/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class StartCaseShift: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var secTF: UITextField!
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var thirdTF: UITextField!
    @IBOutlet weak var fouthTF: UITextField!
    @IBOutlet weak var fifthTF: UITextField!
    @IBOutlet weak var sixthTF: UITextField!
    @IBOutlet weak var seventhTF: UITextField!
    @IBOutlet weak var eighthTF: UITextField!
    @IBOutlet weak var newUserPasView: UIView!
    
    var TF = [UITextField]()
    var indexTF = 0
    var isConected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField()
        
        firstTF.delegate = self
        secTF.delegate = self
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(){
        TF.append(firstTF)
        TF.append(secTF)
        TF.append(thirdTF)
        TF.append(fouthTF)
        if isConected{
            TF.append(fifthTF)
            TF.append(sixthTF)
            TF.append(seventhTF)
            TF.append(eighthTF)
        }
    }
    
    
    @IBAction func numberBtn(_ sender: UIButton) {
        if indexTF < TF.count{
            let textField = TF[indexTF]
            textField.text = "\(sender.currentTitle!)"
            if let nextResponder = textField.superview?.viewWithTag(textField.tag) {
                nextResponder.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            
            indexTF += 1
            print(index)
        }
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        if indexTF > 0 {
            indexTF -= 1
            let textField = TF[indexTF]
            textField.text = ""
            if let nextResponder = textField.superview?.viewWithTag(textField.tag) {
                nextResponder.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        
        
    }
    @IBAction func conectSwitch(_ sender: Any) {
        
        fadeView(view: newUserPasView, delay: 0.1, isHiden: isConected)
        isConected.toggle()
        TF.removeAll()
        textField()
    }
    
    @IBAction func startShift(_ sender: Any) {
        
        
    }
    @IBAction func cancelBtn(_ sender: Any) {
        
    }
}

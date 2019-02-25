//
//  SettingsVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 12/28/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseMessaging
import Toast_Swift
import PopupDialog
import NVActivityIndicatorView



class SettingsVC: UITableViewController, NVActivityIndicatorViewable {

    var user : ElementUser!
    let database = DBBarista()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }

    // MARK: - Table view data source

    func showStandardDialog(animated: Bool = true ) {
        
        // Prepare the popup
        let title = ""
        let message = "Вы уверены, что хотите выйти?"
        
        // Create the dialog
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: true,
                                panGestureDismissal: true,
                                hideStatusBar: true) {
                                    print("Completed")
        }
        
        // Create first button
        let buttonOne = CancelButton(title: "Нет") {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "Да") {
            self.makeSpotClosed()
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
        
    }
    @IBAction func exitBtn(_ sender: Any) {
        showStandardDialog()
    }
    
    func logout(){
        DBBarista().delUser()
        setNotifsEnabled(enabled: false)
        notif = false
        
        AppDelegate.dissableNotif()
        self.performSegue(withIdentifier: "logout", sender: self)
        
    }
    
    func makeSpotClosed(){
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        patchSpotLimit(limit: nil, isClosed: true).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                print(value)
                self.stopAnimating()
                self.logout()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
}

//
//  MainCashBoxVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 2/22/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Toast_Swift
import PopupDialog


class MainCashBoxVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate , UICollectionViewDataSource , NVActivityIndicatorViewable , UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var goHomeBtn: UIButton!
    @IBOutlet weak var searchBarBG: UIView!
    @IBOutlet weak var discoundBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        style()
        stopAnimating()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func style(){
        cornerRatio(view: goHomeBtn, ratio: 8, masksToBounds: false)
        cornerRatio(view: searchBarBG, ratio: 8, masksToBounds: false)
        cornerRatio(view: discoundBtn, ratio: 8, masksToBounds: false)
        cornerRatio(view: cancelBtn, ratio: 8, masksToBounds: false)
        cornerRatio(view: confirmBtn, ratio: 8, masksToBounds: false)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCollection", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemList", for: indexPath)
        return cell
    }

}

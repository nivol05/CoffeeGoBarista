//
//  InventoryVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/6/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit
//import CTSlidingUpPanelYt 

class InventoryVC: UIViewController , UITableViewDelegate, UITableViewDataSource, CTBottomSlideDelegate{
    

    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navController: UIView!
    @IBOutlet weak var heightConstr: NSLayoutConstraint!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var bottomController:CTBottomSlideController?;
    
    var textItems = [String](repeating: "-", count: 20)
    var count = ""
    var lastSelectElem : Int!
    
    var conditionsSliderView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        bottomController = CTBottomSlideController(topConstraint: topConstraint, heightConstraint: heightConstr, parent: view, bottomView: parentView, tabController: self.tabBarController!, navController: self.navigationController, visibleHeight: 20)
        
        print("Count \(textItems)")
        
        bottomController?.delegate = self;
        bottomController?.expandPanel()
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inventoryItem", for: indexPath) as! InventoryItemCell
        
        let textItem = textItems[indexPath.row]
        
        cell.countLbl.text = textItem
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.init(red: 1, green: 120/255, blue: 0, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inventoryItem", for: indexPath) as! InventoryItemCell
        lastSelectElem = indexPath.row
        print(lastSelectElem!)
//        cell.countLbl.text = 
    }
    
    func didPanelCollapse() {
        print("1")
        conditionsSliderView = true
    }
    
    func didPanelExpand() {
        print("2")
//        conditionsSliderView.toggle()
    }
    
    func didPanelAnchor() {
        print("3")
        conditionsSliderView = false
    }
    
    func didPanelMove(panelOffset: CGFloat) {
        cornerRatio(view: parentView, ratio: 20 - (panelOffset * 20), masksToBounds: false)
    }
    
    @IBAction func moveSlideWindow(_ sender: Any) {
        if conditionsSliderView{
            bottomController?.expandPanel()
            conditionsSliderView = false
        } else {
            bottomController?.closePanel()
            conditionsSliderView = true
        }
        
//        conditionsSliderView.toggle()
        
    }
    
    @IBAction func numbersBtn(sender: UIButton) {
        
        count += "\(sender.titleLabel!.text!)"
        
        textItems[lastSelectElem] = count
        
        tableView.reloadData()
        
//        if cashTextSelected{
//
//            cashText += "\(sender.titleLabel!.text!)"
//            cashTextBtn.setTitle(cashText, for: .normal)        }
//        if cardTextSelected{
//
//            cardText += "\(sender.titleLabel!.text!)"
//            cardTextBtn.setTitle(cardText, for: .normal)        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

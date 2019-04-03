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


class MainCashBoxVC: UIViewController,UITableViewDelegate,UITableViewDataSource, NVActivityIndicatorViewable , UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var goHomeBtn: UIButton!
    @IBOutlet weak var searchBarBG: UIView!
    @IBOutlet weak var discoundBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var syrupBtn: UIButton!
    @IBOutlet weak var additionalsBtn: UIButton!
    @IBOutlet weak var sumLbl: UILabel!
    @IBOutlet weak var discoundLbl: UILabel!
    @IBOutlet weak var paymentLbl: UILabel!
    
    var orderItems = [CashOrderItem]()
    
    var discountList = db.getDiscounts()
    
    var currDelegeta: Int!
    var groupsAdapter : GroupCollectionAdapter?
    var productsAdapter : ProductsCashAdapter?
    var addsAdapter : AddsAdapter?
    var syrupAdapter : SyrupAdapter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        style()
        stopAnimating()
        setGroups()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if openInventory{
            
            print("HER")
            
            //            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InventoryVC") as! InventoryVC
            //
            //            navigationController?.show(viewController, sender: nil)
            performSegue(withIdentifier: "openInventory", sender: nil)
            
            openInventory = false
        }
        
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
//        cornerRatio(view: goHomeBtn, ratio: 8, masksToBounds: false)
//        cornerRatio(view: searchBarBG, ratio: 8, masksToBounds: false)
//        cornerRatio(view: discoundBtn, ratio: 8, masksToBounds: false)
//        
//        cornerRatio(view: confirmBtn, ratio: 8, masksToBounds: false)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemList", for: indexPath) as! ItemCell
        let item = orderItems[indexPath.row]
        cell.coffeeNameLbl.text = item.getName()
        cell.countCoffeeLbl.text = String(item.count)
        cell.weightLbl.text = String(item.getDiscount()).getSignedStr()
        cell.discountLbl.text = String(item.discount)
        cell.sizeLbl.text = item.getCup()
        cell.costLbl.text = String(item.getSinglePrice()).getSignedStr()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = EditElementVC()
        cell.cashBoxVC = self
        cell.discountList = discountList
        cell.orderItem = orderItems[indexPath.row].copy()
        cell.listPos = indexPath.row
        presentPopup(popupVC: cell, mainVC: self)
    }
    
    func groupExists(groups: [GroupElem], type: Int) -> Bool{
        for x in groups{
            if x.type == type{
                return true
            }
        }
        return false
    }
    
    func getGroups() -> [GroupElem]{
        var result = [GroupElem]()
        for x in db.getProducts(){
            if !groupExists(groups: result, type: x.product_type){
                result.append(GroupElem(type: x.product_type, img: x.img))
            }
        }
        return result
    }
    
    func setGroups(){
        if groupsAdapter == nil {
            groupsAdapter = GroupCollectionAdapter()
            groupsAdapter?.setData(cashBoxVC: self, list: self.getGroups())
        }
        
        collectionView.delegate = groupsAdapter
        collectionView.dataSource = groupsAdapter
        currDelegeta = 0
    }
    
    func setProducts(type: Int){
        productsAdapter = ProductsCashAdapter()
        productsAdapter?.setData(cashBoxVC: self, list: getProductsForType(type: type))
        
        collectionView.delegate = productsAdapter
        collectionView.dataSource = productsAdapter
        currDelegeta = 1
    }
    
    func addOrderItem(cashOrderItem: CashOrderItem){
        let pos = itemPos(cashOrderItem: cashOrderItem)
        if (pos == -1){
            orderItems.append(cashOrderItem)
        } else {
            orderItems[pos].increase()
        }
        tableView.reloadData()
        setSummary()
    }
    
    func changeOrderItem(pos: Int, cashOrderItem: CashOrderItem){
        orderItems[pos] = cashOrderItem
        tableView.reloadData()
        setSummary()
    }
    
    func removeItem(pos: Int){
        orderItems.remove(at: pos)
        tableView.reloadData()
        setSummary()
    }
    
    func itemPos(cashOrderItem: CashOrderItem) -> Int{
        for i in 0..<orderItems.count{
            if(orderItems[i].equals(item: cashOrderItem)){
                return i
            }
        }
        return -1
    }
    
    func setPercentsList(discount: Int){
//        var orderListNew = [CashOrderItem]()
        for item in orderItems{
            item.setDiscount(value: discount)
//            orderListNew.append(item)
        }
        tableView.reloadData()
        setSummary()
    }
    
    private func setSummary() {
        sumLbl.text = String(getAllPrice()).getSignedStr()
        discoundLbl.text = String(getAllDiscount()).getSignedStr()
        paymentLbl.text = String(getSummaryPrice()).getSignedStr()
    }
    
    private func getAllPrice() -> Int{
        var res = 0
        for item in orderItems{
            res += item.getElemPrice()
        }
        return res
    }
    
    private func getAllDiscount() -> Int{
        var res = 0
        for item in orderItems{
            res += item.getDiscountValue()
        }
        return res
    }
    
    private func getSummaryPrice() -> Int{
        var res = 0
        for item in orderItems{
            res += item.getDiscount()
        }
        return res
    }
    
    func setSearch(text: String){
        switch currDelegeta {
        case 1:
            let filtered = productsAdapter?.list.filter{ (item: ElementProduct) -> Bool in
                return  item.name!.lowercased().contains(text.lowercased())
                
            }
            productsAdapter?.setFoundedResponses(elems: filtered!)
            break
        case 2:
            let filtered = addsAdapter?.list.filter{ (item: AdditionalElem) -> Bool in
                return  item.name.lowercased().contains(text.lowercased())
                
            }
            addsAdapter?.setFoundedResponses(elems: filtered!)
            break
        case 3:
            let filtered = syrupAdapter?.list.filter{ (item: SyrupElem) -> Bool in
                return  item.name.lowercased().contains(text.lowercased())
                
            }
            syrupAdapter?.setFoundedResponses(elems: filtered!)
            break
        default:
            print("SASI")
        }
    }
    
    @IBAction func inventoryBtn(_ sender: Any) {
        presentPopup(popupVC: CashBoxSupplementVC(), mainVC: self)
    }
    
    @IBAction func cleanOrderList(_ sender: Any) {
        orderItems.removeAll()
        tableView.reloadData()
        setSummary()
    }
    
    @IBAction func discountBtn(_ sender: Any) {
        let cell = ListPercents()
        cell.cashBoxVC = self
        cell.discountList = discountList
        presentPopup(popupVC: cell, mainVC: self)
    }
    
    
    @IBAction func additionalBtn(_ sender: Any) {
        if (addsAdapter == nil){
            addsAdapter = AddsAdapter()
            addsAdapter?.setData(cashBoxVC: self, list: db.getAdds())
        }
        
        collectionView.delegate = addsAdapter
        collectionView.dataSource = addsAdapter
        currDelegeta = 2
        
//        presentPopup(popupVC: StartWorkVC(), mainVC: self)
    }
    
    @IBAction func syrypsBtn(_ sender: Any) {
        if (syrupAdapter == nil){
            syrupAdapter = SyrupAdapter()
            syrupAdapter?.setData(cashBoxVC: self, list: db.getSyrups())
        }
        
        collectionView.delegate = syrupAdapter
        collectionView.dataSource = syrupAdapter
        currDelegeta = 3
        
//        presentPopup(popupVC: EndOfShiftVC(), mainVC: self)
    }
    
    @IBAction func setGroupsAction(_ sender: Any) {
        setGroups()
    }
    
    @IBAction func confirmOrder(_ sender: Any) {
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "confirmOrderVC") as! ConfirmOrderVC
        self.navigationController?.pushViewController(cell, animated: true)
        cell.setData(price: getSummaryPrice(),
                     success: {
                        self.orderItems.removeAll()
        })
        
    }
    
}

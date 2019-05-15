//
//  InventoryVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/6/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit
//import CTSlidingUpPanelYt 

class InventoryVC: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CTBottomSlideDelegate{
    

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navController: UIView!
    @IBOutlet weak var heightConstr: NSLayoutConstraint!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var typeNameLbl: UILabel!
    @IBOutlet weak var productTypeTableView: UITableView!
    
    var prevVC: CashBoxSupplementVC!
    
    var bottomController:CTBottomSlideController?;
    
    var isFinishing = false
    var inventoryItems: [StorageItemElem]!
    var inventoryData: [ToJsonElem]!
    var inventoryTypes: [StorageItemType]! = db.getStorageTypes()
    var searchedItems: [StorageItemElem]!
    
    var lastPath: IndexPath?
    var selectedId: Int?
    var selectedCell: InventoryItemCell?
    
    var conditionsSliderView = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allElem = StorageItemType(id: 0, name: "Все")
        inventoryTypes.insert(allElem, at: 0)
        
        searchBar.delegate = self
        
        bottomController = CTBottomSlideController(topConstraint: topConstraint, heightConstraint: heightConstr, parent: view, bottomView: parentView, tabController: self.tabBarController!, navController: self.navigationController, visibleHeight: 25)
        
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = false
        
        
        bottomController?.delegate = self
        bottomController?.expandPanel()
        
        setData()
    }
    
    
    
    func setData(){
        inventoryItems = db.getStorageItems()
        searchedItems = inventoryItems

        switch inventoryType! {
        case .Inventorization:
            titleLbl.text = "Инвентаризация"
            if (!isInventoryInProcess()){
                for item in searchedItems{
                    item.barista_balance = nil
                }
            }
            break
        case .Income:
            titleLbl.text = "Поставки"
            for item in searchedItems{
                item.barista_balance = nil
            }
            break
        case .ProductOutcome:
            titleLbl.text = "Списания"
            for item in searchedItems{
                item.barista_balance = nil
            }
            break
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        productTypeTableView.delegate = self
        productTypeTableView.dataSource = self
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == nil || searchBar.text == ""{
            searchedItems = inventoryItems
        } else {
             searchedItems = inventoryItems.filter( {$0.name.lowercased().contains(searchBar.text!.lowercased())} )
        }
    
        selectedCell = nil
        selectedId = nil
        lastPath = nil
        self.view.endEditing(true)
        tableView.reloadData()
        setSeletedTitle(text: "Найденные")
        isFinishing = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchedItems = inventoryItems
            
            selectedCell = nil
            selectedId = nil
            lastPath = nil
            
            tableView.reloadData()
            setSeletedTitle(text: inventoryTypes[0].name)
            isFinishing = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count : Int!
        
        if tableView == productTypeTableView{
            count = inventoryTypes.count
            return inventoryTypes.count
        }
        
        if tableView == self.tableView{
            count = searchedItems!.count
            if searchedItems == nil{
                count = 0
            }
        }
        
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "inventoryItem", for: indexPath) as! InventoryItemCell
            
            let item = searchedItems![indexPath.row]
            if selectedId == item.id{
                selectedCell = cell
                setSelected(cell: cell, isSelected: true)
            } else {
                setSelected(cell: cell, isSelected: false)
                
            }
            
            cell.nameLbl.text = item.name
            cell.typeLbl.text = item.type
            if (item.barista_balance == nil){
                cell.countLbl.text = "-"
            } else {
                cell.countLbl.text = "\(item.barista_balance!)"
            }
            
            
            return cell
        } else if tableView == productTypeTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectProductTypeCell", for: indexPath) as! SelectProductTypeCell
            let item = inventoryTypes![indexPath.row]
            cell.productTypeLbl.text = item.name
            return cell
        }
        return UITableViewCell()
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.didMoveToSuperview()
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "inventoryItem", for: indexPath) as! InventoryItemCell
            selectedCell = cell
            selectedId = searchedItems![indexPath.row].id
            reload(tableView: self.tableView)
//            tableView.reloadRows(at: [indexPath, lastPath ?? indexPath], with: UITableViewRowAnimation.automatic)
//
            lastPath = indexPath
        } else if tableView == productTypeTableView{
            print("type")
            bottomController?.closePanel()
            conditionsSliderView = true
            let item = inventoryTypes![indexPath.row]
            setSeletedTitle(text: item.name)
            
            if(item.id == 0){
                searchedItems = inventoryItems
            } else {
                searchedItems = inventoryItems.filter( {$0.product_type == item.id} )
            }
            isFinishing = false
            self.tableView.reloadData()
        }
        
    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print(selectedId ?? 0)
//        if cell == selectedCell{
//            setSelected(cell: selectedCell!, isSelected: true)
//        }
//    }
    
    func reload(tableView: UITableView) {
        
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
        
    }
    
    func setSeletedTitle(text: String){
        typeLbl.text = ("Тип: \(text)")
    }
    
    private func getInventoryData(){
        inventoryData = [ToJsonElem]()
        for item in inventoryItems{
            if (item.barista_balance != nil){
                inventoryData.append(ToJsonElem(amount: item.barista_balance!, storage_item: item.id))
            }
        }
    }
    
    func finishInventory(){
        let incSize = db.getInventory().count
        print("Inv \(incSize)")
        let elem = InventoryElem.init(
            id: incSize + 1,
            spot: getSpotId(),
            value: StringUtils.toJsonString(elems: inventoryData),
            date: getCurrentDate(),
            time: getTimeNow(),
            barista_name: "BARISTA")
        db.setInventory(x: elem)
        
        setInventoryProcess(value: false)
    }
    
    func finishIncome(){
        
        let incSize = db.getIncomes().count
        print("Inc \(incSize)")
        let incomeElem = IncomeElem.init(
            id: incSize + 1,
            spot: getSpotId(),
            value: StringUtils.toJsonString(elems: inventoryData),
            date: getCurrentDate(),
            time: getTimeNow())
//        db.setIncomes(x: incomeElem)
//        print(db.setIncomes(x: incomeElem))
        
        let cell = OutcomeVC()
        cell.priceCostText = "Сумма поставки:"
        cell.reasonCostText = "Поставщик:"
        cell.incomeElem = incomeElem
        cell.finishFunc = {
            db.setIncomes(x: incomeElem)
        }
        presentPopup(popupVC: cell, mainVC: self)
    }
    
    func finishProductOutcome(){
        let incSize = db.getProductOutcomes().count
        print("Product Outcome \(incSize)")
        let elem = ProductOutcomeElem.init(
            id: incSize + 1,
            spot: getSpotId(),
            value: StringUtils.toJsonString(elems: inventoryData),
            date: getCurrentDate(),
            time: getTimeNow())
        db.setProductOutcome(x: elem)
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
    
    func setSelected(cell: InventoryItemCell, isSelected: Bool) {
        var whiteValue = 0
        if (isSelected){
            cell.bg.backgroundColor = UIColor.init(red: 1, green: 120/255, blue: 0, alpha: 1)
            whiteValue = 1
        } else {
             cell.bg.backgroundColor = UIColor.init(white: 1, alpha: 1)
        }
        cell.nameLbl.textColor = UIColor.init(white: CGFloat(whiteValue), alpha: 1)
        cell.typeLbl.textColor = UIColor.init(white: CGFloat(whiteValue), alpha: 1)
        cell.countLbl.textColor = UIColor.init(white: CGFloat(whiteValue), alpha: 1)
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
    
    @IBAction func deleteBtn(_ sender: Any) {
//        tableView.reloadRows(at: [lastPath!], with: UITableViewRowAnimation.none)
        
        var selectedText = selectedCell!.countLbl.text ?? ""
        if selectedText.count == 1 {
            selectedText = "-"
        } else {
            selectedText.removeLast()
        }
        selectedCell!.countLbl.text = selectedText
        
        inventoryItems.first(where: {$0.id == selectedId})?.barista_balance = Int(selectedText)
        
        searchedItems.first(where: {$0.id == selectedId})?.barista_balance = Int(selectedText)
        
        isFinishing = false
    }
    
    
    
    @IBAction func numbersBtn(sender: UIButton) {
        
        if (selectedId != nil){
            
//            tableView.reloadRows(at: [lastPath!], with: UITableViewRowAnimation.none)
            
            
            var selectedText = selectedCell!.countLbl.text ?? ""
            if selectedText == "-" || selectedText == "0" {
                selectedText = ""
            }
            if selectedText.count < 7{
                selectedText.append(sender.currentTitle!)
                selectedCell!.countLbl.text = selectedText
            }

            inventoryItems.first(where: {$0.id == selectedId})?.barista_balance = Int(selectedText)
            
            searchedItems.first(where: {$0.id == selectedId})?.barista_balance = Int(selectedText)
            
        }
        
        isFinishing = false
        
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
        print("scuko")
        if inventoryType == InventoryType.Inventorization{
            getInventoryData()
            
            if (inventoryData.count > 0){
                db.setStorageItems(list: inventoryItems)
                setInventoryProcess(value: true)
            } else {
                
                setInventoryProcess(value: false)
            }
        }
        
        if inventoryType == InventoryType.Income{
            inventoryType = nil
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        if (!isFinishing){
            let foundItems = inventoryItems.filter({$0.barista_balance != nil})
            if (foundItems.count != 0){
                searchedItems = foundItems
                tableView.reloadData()
                isFinishing = true
                setSeletedTitle(text: "Только заполненные")
            } else {
                self.view.makeToast("Ничего не заполнено")
            }
        } else {
            self.getInventoryData()
            
            switch inventoryType! {
            case .Inventorization:
                finishInventory()
                self.dismiss(animated: true, completion: nil)
                break;
            case .Income:
                finishIncome()
                break;
            case .ProductOutcome:
                finishProductOutcome()
                self.dismiss(animated: true, completion: nil)
                break;
            }
            
            
        }
    }
}

//
//  OffineOrderListVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/14/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class OffineOrderListVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var order: OrderOffline!
    var orderItems: [OrderItemOfflineElem]!
    
    private let products = db.getProducts()
    private let additionals = db.getAdds()
    private let syrups = db.getSyrups()

    var orderIndex = ""
    
    @IBOutlet weak var orderIndexLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib.init(nibName: "OfflineOrderListCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "OfflineOrderListCell")
        orderIndexLbl.text = orderIndex
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setData(order: OrderOffline){
        self.order = order
        
        self.orderItems = db.getItemsOfflineForOrder(id: self.order.id)
        print(self.orderItems.count)
//        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if orderItems == nil {
            return 0
        }
        return orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfflineOrderListCell", for: indexPath) as! OfflineOrderListCell
        
        let item = orderItems[indexPath.row]
        cell.nameLbl.text = item.getName(products: products, adds: additionals, syrups: syrups)
        cell.cupLbl.text = "\(item.getCup(products: products)) мл"
        
        cell.costLbl.text = String(item.getSinglePrice(products: products, adds: additionals, syrups: syrups)).getSignedStr()
        
        cell.countLbl.text = String(item.count)
        cell.discountLbl.text = String(item.discount)
        cell.fullPriceLbl.text = String(item.getFullPrice(products: products, adds: additionals, syrups: syrups)).getSignedStr()
        
        return cell
    }

    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  OffineOrderListVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/14/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class OffineOrderListVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib.init(nibName: "OfflineOrderListCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "OfflineOrderListCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfflineOrderListCell", for: indexPath) as! OfflineOrderListCell
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

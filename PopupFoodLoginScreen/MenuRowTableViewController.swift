//
//  MenuRowTableViewController.swift
//  PopupFood
//
//  Created by Anita on 2017-02-28.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase

class MenuRowTableViewController: UITableViewController {
    
    var foodMenu = [Menu]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMenu()
    }

    func fetchMenu() {
        FIRDatabase.database().reference().child("chef").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let menu = Menu()
                menu.setValuesForKeys(dictionary)
                //Call array of data created above
                self.foodMenu.append(menu)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                //print(menu.food, menu.price)
            }
            
        }, withCancel: nil)
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}

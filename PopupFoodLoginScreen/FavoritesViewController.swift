//
//  FavoritesViewController.swift
//  PopupFood
//
//  Created by Barbara Akaeze on 2017-03-07.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FavoritesViewController: UITableViewController {
    
    var foodMenu = [Menu]()
    //Instantiate menu class
    var menu : Menu?
    
    let cellId = "favourites"
    
    //Nav Bar
    func showNavBar() {
        navigationItem.title = "Favorites"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBar()
        fetchUserFavourites()
        
    }
    //FETCH FAVOURITES FOR INDIVIDUAL USER
    func fetchUserFavourites() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        //Get user table, then userID, in user ID, get the favourites
        let ref = FIRDatabase.database().reference().child("user-favourites").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            //Get menuID within favourites
            let menuID = snapshot.key
            let menuReference = FIRDatabase.database().reference().child("menu").child(menuID)
            
            menuReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                //store chef/menu info in "snapshot" and display snapshot
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let menu = Menu()
                    
                    self.foodMenu.append(menu)
                    
                    //This calls the entire database for menu input by a user
                    menu.food = dictionary["food"] as? String
                    menu.price = dictionary["price"] as? String
                    menu.foodImageUrl = dictionary["foodImageUrl"] as? String
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    //Set up number of cells in Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return foodMenu.count
    }
    
    //Display images, test and amount in cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DisplayFavouritesTableViewCell
        
        let menu = foodMenu[indexPath.row]
        cell.foodLabel.text = menu.food
        cell.foodPrice.text = menu.price
        
        if let foodImageUrl = menu.foodImageUrl {
            cell.foodImage.sd_setImage(with: URL(string: foodImageUrl))
        } else {
            cell.foodImage.image = UIImage(named: "test_pizza")
        }
        return (cell)
    }
}

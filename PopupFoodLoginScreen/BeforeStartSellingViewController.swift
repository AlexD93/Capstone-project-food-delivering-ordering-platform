//
//  BeforeStartSellingViewController.swift
//  PopupFood
//
//  Created by Student on 2017-02-21.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

//OLEK class!!!!!! for Before selling page with CANCEL and ADD button
import UIKit
import Firebase
import FirebaseAuth

class BeforeStartSellingViewController: UITableViewController {
    
    //Test data to display array of food items
    //let foodMenu = ["test_pizza", "pasta", "defaultImage"]
    //Menu array to display food items
    var foodMenu = [Menu]()
    let cellId = "cell"
    
    override func viewDidLoad() {

        fetchUserMenu()
    }
    
    //FETCH ITEMS BY SINGLE USER ENTRY
    func fetchUserMenu() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user").child(uid).child("menu")
        ref.observe(.childAdded, with: { (snapshot) in
            
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

 /*   //FETCH ALL MENU FROM DATABASE
    func fetchMenu() {

        FIRDatabase.database().reference().child("menu").observe(.childAdded, with: { (snapshot) in
            
            //store chef/menu info in "snapshot" and display snapshot
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let menu = Menu()
                
                self.foodMenu.append(menu)

                //This calls the entire database for menu input by a user
                menu.food = dictionary["food"] as? String
                menu.price = dictionary["price"] as? String
                menu.foodImageUrl = dictionary["foodImageUrl"] as? String

                //self.foodMenu.append(menu)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            }

        }, withCancel: nil)
    }*/
    
    //Set up number of cells in Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
     return foodMenu.count
    }
    
    //Display images, test and amount in cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DisplayMenuTableViewCell
        
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
    
    //plus button functionality
    @IBAction func addButton(_ sender: Any) {
            startSelling()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        goBackToLoggedInView()
    }

    //This methid displays navigation Bar
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //Call viewcontroller and navigation bar for selling page
    func startSelling() {
     let storyboard = UIStoryboard(name: "startSelling", bundle: nil)
     let controller = storyboard.instantiateViewController(withIdentifier: "startSelling") as UIViewController
     self.navigationController?.pushViewController(controller, animated: true)
     }
    
    func goBackToLoggedInView(){
        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}



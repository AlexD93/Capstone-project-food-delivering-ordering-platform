//
//  PresentViewController.swift
//  PopupFood
//
//  Created by Anita on 2017-03-03.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

class PresentViewController: UIViewController {
    
    override func viewDidLoad() {
        showClickedFoodCell()
    }

    func returnHomePage() {
        
        let signInViewCOntroller = SignInViewController()
        let nextViewController: UINavigationController = UINavigationController(rootViewController: signInViewCOntroller)
        self.present(nextViewController, animated: true, completion: nil)

    }
    
    
    func showClickedFoodCell() {
        let storyboard = UIStoryboard(name: "mainFoodCell", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "foodCell") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //Fetch every item in the database without specific user id
    //CURRENTLY NOT IN USE ======
    /*func fetchMenu() {
        
        FIRDatabase.database().reference().child("menu").observe(.childAdded, with: { (snapshot) in
            
            //Add firebase
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
                    self.collectionView?.reloadData()
                }
                
            }
            
        }, withCancel: nil)
    } //===========
 */


}

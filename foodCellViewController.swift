//
//  foodCellViewController.swift
//  PopupFood
//
//  Created by Anita on 2017-03-14.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class foodCellViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var messageButton: UIButton? = nil
    //@IBOutlet weak var messageButton: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton? = nil
    //@IBOutlet weak var favouriteButton: UIImageView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    //@IBOutlet weak var chefUsername: UILabel!
    @IBOutlet weak var chefUsername: UILabel!
    
    //Store Menu in an array
    var menuArray = [Menu]()
    //Instantiate menu class
    var menu: Menu? {
        didSet{
            navigationItem.title = menu?.food

            displayFoodItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Display message button image
        messageBtn()
       // favouriteBtnClicked()
        //Check if fave is in DB
        checkIfFavouriteExists()

    }
    //Get item details from DB and display to screen
    func displayFoodItems() {
        //Declare menuID to be used to retrieve menu details
        
        guard let menuID = menu?.menuID, let chefName = menu?.userName else {
            return
        }
        //link menu table in DB and get menuID
        let menuReference = FIRDatabase.database().reference().child("menu").child(menuID)
        menuReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //store chef/menu info in "snapshot" and display snapshot
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.menuArray.append(self.menu!)
                self.foodLabel.text = dictionary["food"] as? String
                
                self.foodImage.contentMode = .scaleToFill
                if let foodImageUrl = dictionary["foodImageUrl"] as? String {
                    self.foodImage.sd_setImage(with: URL(string: foodImageUrl))
                } else {
                    self.foodImage.image = UIImage(named: "defaultImage")
                }
                self.priceLabel.text = dictionary["price"] as? String
                self.cuisineLabel.text = dictionary["cuisine"] as? String
                self.descriptionLabel.text = dictionary["foodDescription"] as? String
                self.chefUsername.text = (chefName + "'s other food items")
                
            }
        }, withCancel: nil)
    }
    
    //Add Favorites to the Database
    private func registerFavouritesIntoDatabaseWithUserID() {
        
        guard let userID = FIRAuth.auth()?.currentUser?.uid, let menuID = menu?.menuID else{
            return
        } //Add user ID to favorites
        //This remmebers which user likes what
        let userFaveFood = FIRDatabase.database().reference().child("user-favourites").child(userID)
        userFaveFood.updateChildValues([menuID: 1])
        
    }
    
    //Declare pressed variable for favourites button
    var favClicked = false
    //Declare images for favourite button
    let favBtn = UIImage(named: "favorites")?.withRenderingMode(.alwaysOriginal)
    let clickFavBtn = UIImage(named: "full_heart")?.withRenderingMode(.alwaysOriginal)
    
    //Declare method to display Message image for message button
    func messageBtn() {
        if let msgButton = UIImage(named: "message")?.withRenderingMode(.alwaysOriginal) {
            messageButton?.setImage(msgButton, for: .normal)
        }
    }

    @IBAction func messageBtn(_ sender: Any) {
        displaySendMessagePage()
    }
    
    @IBAction func favouriteBtn(_ sender: UIButton) {
        
        if !favClicked {
            favouriteBtnClicked()
        }
        else {
            favouriteBtnNotClicked()
        }
    }
    
    func favouriteBtnNotClicked() {
        favouriteButton?.setImage(favBtn, for: .normal)
        favClicked = false
    }
    
    func favouriteBtnClicked() {
        favouriteButton?.setImage(clickFavBtn, for: .normal)
        favClicked = true
        registerFavouritesIntoDatabaseWithUserID()
        
    }
    
    func displaySendMessagePage() {
        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "sendChefMessage") as! sendMessageCollectionController
        controller.menu = menu
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func checkIfFavouriteExists() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        //Get user table, then userID, in user ID, get the favourites
        let ref = FIRDatabase.database().reference().child("user-favourites").child(uid)
        ref.observe(.value, with: { (snapshot) in
            //Get menuID within favourites
            let menuID = snapshot.key
            let menuReference = FIRDatabase.database().reference().child("menu").child(menuID)
            
            menuReference.observeSingleEvent(of: .value, with: { (snapshot) in

                let values = snapshot.key //as? [String]
            
                //store chef/menu info in "snapshot" and display snapshot
                        if menuID == self.menu?.menuID  {
                            self.favouriteBtnClicked()
                        }else {
                        self.favouriteBtnNotClicked()
                        }
                
                
            }, withCancel: nil)
        }, withCancel: nil)
    }

}

//
//  defaultPageViewController.swift
//  PopupFood
//
//  Created by Anita on 2017-02-07.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

//Iteration 1
class defaultPageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var cellId = "cellID"
    var foodMenu = [Menu]()
    let userDetails = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        //DEFAULT PAGE CODE
        navigationController?.navigationBar.isTranslucent = false
        logoForNavbar()
        
        collectionView?.backgroundColor = UIColor.white
        //Register cellID
        collectionView?.register(foodCell.self, forCellWithReuseIdentifier: cellId)
        
        //SET UP NAV BAR BUTTONS
        setupNavBarButtons()
        fetchMenu()
        
    }
    
    func logoForNavbar() {
        //Set up home button for profile page
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "logo2_new"), for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 120, height: 40)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    //SET UP NAV BAR FUNC
    func setupNavBarButtons() {
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let profileIconBtn = UIBarButtonItem(image: UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showProfile))
        
        navigationItem.rightBarButtonItems = [profileIconBtn, searchBarButtonItem]

    }
    
    //Method to handle search button in future
    func handleSearch() {
        print(123)
    }
    
    //Pass to show Profile class or method
    func showProfile() {
    
        //Check if user is logged in
        FIRAuth.auth()?.addStateDidChangeListener{ auth, user in
            
            //If user is logged in, show profile storyboard
            if user != nil {
                
                //If user is logged in, show profile storyboard
                self.displayProfilePage()
            }
            else{
                
                //If user is NOT logged in, show signup storyboard
                self.displaySignUpPage()
                
            }
        }
    }
    
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
                    self.collectionView?.reloadData()
                }
                
            }
            
        }, withCancel: nil)
    }

    
    //DEFAULT PAGE CODE
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodMenu.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! foodCell
        
        let menu = foodMenu[indexPath.row]
        
        cell.titleLabel.text = menu.food
        cell.subtitleTextView.text = menu.price
        
        //Display food image
        if let foodImageUrl = menu.foodImageUrl {
            let url = URL(string: foodImageUrl)
            cell.thumbnailImageView.sd_setImage(with: url)
        } else {
            cell.thumbnailImageView.image = UIImage(named: "test_pizza")
        }
        
        //Display user profile image in menu cell on home page
        if let profileImageUrl = menu.profileImageUrl {
            let url = URL(string: profileImageUrl)
            cell.userProfileImage.sd_setImage(with: url)
        } else {
            cell.userProfileImage.image = UIImage(named: "defaultImage")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width:view.frame.width, height:height + 16 + 68)
    }
    
    //Edit lineSpacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    
    func displayProfilePage() {
        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func displaySignUpPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignUpSocialMedia") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }

}






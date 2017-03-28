//
//  MenuBarNavigation.swift
//  PopupFood
//
//  Created by Barbara Akaeze on 2017-03-10.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

//BARBARA: This class will handle all navigation to carry out onClick or swipe features
//on the menubar ie Home, Favorites, Messages, Cart.

class MenuBarNavigation: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Display Favorites Page
        displayFavorites()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var menuBar : MenuBar = {
        let mb = MenuBar()
        //insert mb.class to send method
       // mb.homeController = self
        return mb
    }()
    
    func displayFavorites() {
        
        let storyboard = UIStoryboard(name: "favoritesPage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FavoritesPage") as UIViewController
        self.present(controller, animated: true)
    }
   
}

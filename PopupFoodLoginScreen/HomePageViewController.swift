//
//  HomePageViewController.swift
//  PopupFood
//
//  Created by Anita on 2017-02-17.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!
    
    func setNavigationItems() {
        
        navigationBar.title = "Popup Food" //align left
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

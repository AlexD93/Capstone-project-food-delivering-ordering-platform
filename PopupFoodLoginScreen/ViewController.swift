//
//  ViewController.swift
//  PopupFoodLoginScreen
//
//  Created by Anita Conestoga on 2017-01-27.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    @IBOutlet weak var xButton: UIButton!
    @IBAction func closeBtn(_ sender: UIButton) {
        
        displayHomePage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true;
        closeBtn()
    }
    
    func closeBtn() {
        let closeButton = UIImage(named: "xBtn")?.withRenderingMode(.alwaysOriginal)
        xButton.setImage(closeButton, for: .normal)
    }
    
    func displayHomePage() {
        let storyboard = UIStoryboard(name: "defaultTimeline", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "initialController") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    

}

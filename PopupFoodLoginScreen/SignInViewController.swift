//
//  SignInViewController.swift
//  PopupFood
//
//  Created by Anita Conestoga on 2017-02-01.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit //Import Facebook SignIn Kit
import GoogleSignIn //Import GoogleSignIn kit

//SIGN IN PAGE WITH FACEBOOK AND GOOGLE BUTTONS
class SignInViewController: UIViewController {
    
    var signUpController: SignUpViewController?
    
    //Field Declaration
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    //////
    @IBAction func facebookBtn(_ sender: Any) {
        signUpController?.handleCustomFBLogin()
    }
    @IBAction func googleBtn(_ sender: Any) {
        signUpController?.handleCustomGoogleLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //If user is signed in, display homepage
        FIRAuth.auth()?.addStateDidChangeListener{ auth, user in
            
            if user != nil {
                self.returnHomePage()
            }
        }
    }
    
    //guard let uid = FIRAuth.auth()?.currentUser?.uid
    
    //      print(12345)
    
    //else {
    //  print("dklhvdlvhbdj")
    //self.returnHomePage()
    //return
    //}
    
    
    //If user is signed in, display homepage
    //FIRAuth.auth()?.addStateDidChangeListener{ auth, user in
    
    //    if user != nil {
    //    self.returnHomePage()
    //    }
    //}
    
    
    //}
    
    //Implementation for Sign In Button
    
    @IBAction func signInBtn(_ sender: UIButton) {
        
        handleSignIn()
    }
    
    func handleSignIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text
            else {
                print ("Incorrect details entered")
                return
        }
        
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                print(error as Any)
                return
            }
                
            else{
                print("User Logged In")
            }
        })
        
    }
    
    
    
    
    func returnHomePage() {
        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "newhomePage") as! HomeAfterSignIn
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //    func displayLandingPage() {
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        let controller = storyboard.instantiateViewController(withIdentifier: "landingVC") as UIViewController
    //        self.navigationController?.pushViewController(controller, animated: true)
    //    }
    
    @IBAction func backToLandingPage(_ sender: Any) {
        //displayLandingPage()
    }
    
}

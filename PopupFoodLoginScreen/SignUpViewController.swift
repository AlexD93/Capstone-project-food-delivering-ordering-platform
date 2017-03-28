//
//  SignUpViewController.swift
//  PopupFood
//
//  Created by Anita Conestoga on 2017-02-01.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

//Barbara -22:53 - 05022016

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit //Import Facebook SignIn Kit
import GoogleSignIn //Import GoogleSignIn kit

//NEW PROJECT!!!!!
class SignUpViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupFacebookButton() //Method to set up Facebook button
        
        setupGoogleButton() //Method to set up Google Button
        
    }
    
    //Google Method called here
    
    fileprivate func setupGoogleButton() {
        
        //Custom Google Sign in Button
        let customButton = googleButton
        customButton?.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    func handleCustomGoogleLogin() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    //Facebook Method called here
    
    //ADD CUSTOM FACEBOOK BUTTON HERE
    
    fileprivate func setupFacebookButton() {
        let customFBButton = facebookButton
        customFBButton?.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
    }
    
    //FACEBOOK CLICK FUNCTIONALITY
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Button failed", err as Any)
                return
            }
            
            self.showEmailAddress()
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print (error)
            return
        }
        showEmailAddress()
    }
    
    func showEmailAddress() {
        //Save details in Firebase Auth
        let accessToken = FBSDKAccessToken.current()
        guard (accessToken?.tokenString) != nil else
        { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: {(user,
            error) in
            if error != nil {
                print("Something went wrong with facebook: ", error as Any)
                return
            }
            print("Successfully logged in with our user: ", user as Any)
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start Graph request: ", err as Any)
                return
            }
            
            print(result as Any)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func displaySignInPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "signInPage") as! SignInViewController
        controller.signUpController = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func displaylandingPage() {
        
        let storyboard = UIStoryboard(name: "defaultTimeline", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "testing") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

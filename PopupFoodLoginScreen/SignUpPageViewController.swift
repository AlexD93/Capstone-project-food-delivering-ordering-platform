//
//  SignUpPageViewController.swift
//  PopupFood
//
//  Created by Anita Conestoga on 2017-02-01.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpPageViewController: UIViewController {

    // Fields Declaration
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var RepasswordTextField: UITextField!

    var errorMessage = String()
    
    //Method for alert box when one of the fields were formmated wrong ------ Olek
    func generalAlert(){
        let alert = UIAlertController(title: "Warning", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Correct It", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Impelmenation for Sign Up button
    @IBAction func signUpBtn(_ sender: UIButton) {
        handleRegister()
        
        goToHomePage()
    }
    
    
    //Olek/Sara method is used for email validation
    var emailErrorMessage  = String()
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: emailTextField.text!)
        
        if(emailTest == true){
            return true
        }
        
        else
        {
            emailErrorMessage = "Incorrect format of an email! \n"
            return false
        }
    }//end of isValidEmail method
    
    
    var passwordsMatchErrorMessage = String()
    
    func isPaswordsMatch() -> Bool {
        if(passwordTextField.text != RepasswordTextField.text){
            //password fields are not match
            passwordsMatchErrorMessage = "Passwords are not match! \n"
            return false
        }
        return true
    }//end of isPaswordsMatch method
    
    var passwordsEmptyErrorMessage = String()
    
    func isPasswordsEmpty() -> Bool {
        if (passwordTextField.text == "" && RepasswordTextField.text == ""){
            //password fields are empty
            passwordsEmptyErrorMessage = "Password fields are empty \n"
            return false
        }
        return true
    }//end of isPasswordsEmpty method
    
    
    func createUserInDataBase()
    {
        guard let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text else{
                print ("Form filled inappropriately")
                return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error ) in
            
            if error != nil {
                print(error as Any)
                return
            }
            else {
                print("User Created")
            }
            
            //Push entered information to Firebase Database
            //Guard statment gives us access to UID similar to email, Username and Password above.
            guard let uid = user?.uid else {
                return
            }
            //Collect entered User information and input in Database
            var ref: FIRDatabaseReference!
            
            ref = FIRDatabase.database().reference()
            let usersReference = ref.child("user").child(uid)
            let values = ["name": username, "email": email, "password": password]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err as Any)
                    return
                }
                print ("User Data saved to Firebase Database!")
            })
        })
    }//end of createUserInDataBase

    
    func handleRegister() {
//please do not delete this block!!!!!!!!!!!! - START
        /*let pass1 = isPasswordsEmpty()
        let pass2 = isPaswordsMatch()
        let email = isValidEmail()
        
        if(email){
            errorMessage = emailErrorMessage
            print(errorMessage)
            generalAlert()
            return
        }
        
        if((pass2) && (email))
        {
            errorMessage = emailErrorMessage + passwordsMatchErrorMessage
            print(errorMessage)
            generalAlert()
            return
        }
        
        if(!(pass1 && pass2 && email))
        {
            errorMessage = emailErrorMessage + passwordsMatchErrorMessage + passwordsEmptyErrorMessage
            print(errorMessage)
            generalAlert()
            return
        }*/
//please do not delete this block!!!!!!!!!!!!!!!! - END
        //else
        //{
            //added this else clause for creating a user and sending them data to database
            createUserInDataBase()
        //}//Olek/Sara end of else clause where user is adding if password and email matches requirements
        
    }//end of handleRegister method
    
    
    func goToHomePage() {
        let signInViewCOntroller = SignInViewController()
        let nextViewController: UINavigationController = UINavigationController(rootViewController: signInViewCOntroller)
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}//end of SignUpPageViewController

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

    var emailsArray = [User]()
    var user : User?
    
    // Fields Declaration
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var RepasswordTextField: UITextField!

    var errorsArray = [String]()

    var errorMessage = String()
    
    //Method for alert box when one of the fields were formmated wrong ------ Olek
    func generalAlert(){
        let alert = UIAlertController(title: "Warning", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Correct It", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Alert box for a situation when email is already exists in the database
    func emailExistsAlert(){
        let alert = UIAlertController(title: "Warning", message: "Typed email address is already in use, please input another one", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Change It", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Impelmenation for Sign Up button
    @IBAction func signUpBtn(_ sender: UIButton) {
        handleRegister()
    }
    
    
    //Olek/Sara method is used for email validation
    var emailErrorMessage  = String()
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: emailTextField.text!)
        
        if(emailTextField.text == ""){
            errorsArray.append("Email field is empty!");
            return false
        }
        
        if(emailTest != true){
            errorsArray.append("Incorrect format of an email!");
            return false
        }
        return true
    }//end of isValidEmail method
    
    
    //Method is used for username field validation
    func isUserNameEmpty() -> Bool {
        if(usernameTextField.text == ""){
            errorsArray.append("Username field is empty!")
            return false
        }
        return true
    }//end of username field validation
    
    
    //Method is used for password's fields match validation
    func isPaswordsMatch() -> Bool {
        if(passwordTextField.text != RepasswordTextField.text){
            //password fields are not match
            errorsArray.append("Passwords are not match!");
            return false
        }
        return true
    }//end of isPaswordsMatch method
    
    
    //Method is used for password's fields empty validation
    func isPasswordsEmpty() -> Bool {
        if (passwordTextField.text == "" && RepasswordTextField.text == ""){
            //password fields are empty
            errorsArray.append("Password fields are empty!");
            return false
        }
        return true
    }//end of isPasswordsEmpty method
    
    
    func handleRegister() {
        
        //getAllEmailsFromDB()

        errorsArray = [String]()//empty our errorsArray before checks will performe
        
        isValidEmail()
        isUserNameEmpty()
        isPasswordsEmpty()
        isPaswordsMatch()
        
        if(errorsArray.isEmpty){
            createUserInDataBase()//create user and send it to databse
        }
        
        else{
            errorMessage = errorsArray.joined(separator: "\n")//concatinate strings from an array and format an error message from them
            generalAlert()
        }
//Olek/Sara end of else clause where user is adding if password and email matches requirements
        
    }//end of handleRegister method
    
    
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
                self.emailExistsAlert()//calls an alert box if email is already exists in a databse Olek
                //print(error as Any)
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
                self.goToHomePage()// call goToHomePage method
            })
        })

    }//end of createUserInDataBase
    
    
    func goToHomePage() {
        let signInViewCOntroller = SignInViewController()
        let nextViewController: UINavigationController = UINavigationController(rootViewController: signInViewCOntroller)
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}//end of SignUpPageViewController

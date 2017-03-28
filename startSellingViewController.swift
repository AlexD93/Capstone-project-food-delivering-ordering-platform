//
//  startSellingViewController.swift
//  PopupFood
//
//  Created by Barbara Akaeze on 2017-02-13.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

class startSellingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cuisineTypeLabel: UILabel!
    @IBOutlet weak var cuisineTypePickerView: UIPickerView!
    @IBOutlet weak var menuNameTextField: UITextField!
    //@IBOutlet weak var menuDescriptionTextField: UITextField!
    @IBOutlet weak var menuDescriptionTextView: UITextView!
    @IBOutlet weak var enterPriceTextField: UITextField!
    @IBOutlet weak var foodImage: UIImageView!

    var foodMenu = [Menu]()

    var userDetails: User! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cuisineTypePickerView.delegate = self
        cuisineTypePickerView.dataSource = self
    }

    @IBAction func startSellingBtn(_ sender: Any) {
        handleStartSelling()
        goBackToStartSelling()
    }

    //BARBARA: Create an array for the picker view
    var cuisine = ["", "Carribbean", "Chinese", "French","Indian", "Italian", "Thai", "Other"]
    
    //Go back to the orevious page of menu list

    @IBAction func backButton(_ sender: Any) {
        goBackToStartSelling()
    }
    
    @IBAction func changeFoodImage(_ sender: AnyObject) {
        
        let selectImage = UIImagePickerController()
        selectImage.delegate = self
        
        selectImage.allowsEditing = true
        
        selectImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        //selectImage.allowsEditing = false
        self.present(selectImage, animated: true)
    }
    
    //Select image from gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //store selected image in the variable below
        var selectedImagefromGallery: UIImage?
        
        //Select edited image first
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImagefromGallery = editedImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //If edited image not available, then select original image
            selectedImagefromGallery = originalImage
        }
        //display selected type of image to imageView
        if let selectedImage = selectedImagefromGallery {
            foodImage.image = selectedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //This method handles collecting information entered by the user and storing in the database
    func handleStartSelling() {
        guard let chefID = FIRAuth.auth()?.currentUser?.uid else{
            return
        }

        guard let foodName = menuNameTextField.text, let foodDescription = menuDescriptionTextView.text, let price = enterPriceTextField.text, let cuisine = cuisineTypeLabel.text else {
            print("Data filled is incorrect")
            return
        }
        
        //after user is successfully autheticated
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("food_Images").child("\(imageName).png")
        if let uploadData = UIImagePNGRepresentation(self.foodImage.image!) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                if let foodImageUrl = metadata?.downloadURL()?.absoluteString {

                    let values = ["food": foodName, "foodDescription": foodDescription, "price": "$" + price, "cuisine": cuisine, "foodImageUrl": foodImageUrl, "chefID": chefID]
                    
                    self.registerChefIntoDatabaseWithMenuID(values: values)
                }
            })
        }
    }
    
    //Create menu table to store user entry
    //In user table, sorted by currently signed in user; Create "menu" sub node 
    //OR child node in user table, then give the menu child node the value of 
    //menuID from menu table
    private func registerChefIntoDatabaseWithMenuID(values: [String: Any]) {
        
        guard let userID = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        
        let ref = FIRDatabase.database().reference().child("menu")
        let childRef = ref.childByAutoId()

        childRef.updateChildValues(values) { (err, ref) in
            
            if err != nil {
                print (err as Any)
                return
            }
            let menuId = childRef.key
            let userMenuChild = FIRDatabase.database().reference().child("user").child(userID).child("menu")
            userMenuChild.updateChildValues([menuId: 1])
            //print ("User stored in database")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        //navigationItem.title = "Start Selling"
    }
    
    //Call a new class to instantiate method
    /*var profileController: BeforeStartSellingViewController?
     self.profileController?.goBackToLoggedInView()*/
    
    func goBackToStartSelling() {
        let storyboard = UIStoryboard(name: "startSelling", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BeforeSellingPage") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Return amount of value in array
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cuisine.count
    }
    //identify current row on picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cuisine[row]
    }
    //set current row of picker view on label
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cuisineTypeLabel.text = cuisine[row]
    }
}

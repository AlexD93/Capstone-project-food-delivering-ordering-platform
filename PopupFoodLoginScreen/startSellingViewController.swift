//
//  startSellingViewController.swift
//  PopupFood
//
//  Created by Barbara Akaeze on 2017-02-13.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase

class startSellingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cuisineTypeLabel: UILabel!
    @IBOutlet weak var cuisineTypePickerView: UIPickerView!
    @IBOutlet weak var menuNameTextField: UITextField!
    @IBOutlet weak var menuDescriptionTextField: UITextField!
    @IBOutlet weak var enterPriceTextField: UITextField!
    @IBOutlet weak var foodImage: UIImageView!
    
    
    var user: User?

    @IBAction func startSellingBtn(_ sender: Any) {
        handleStartSelling()
    }
    

    //BARBARA: Create an array for the picker view
    var cuisine = ["Carribbean", "Chinese", "French","Indian", "Italian", "Thai", "Other"]
    
    //Go back to the orevious page of menu list

    @IBAction func backButton(_ sender: Any) {
        goBackToStartSelling()
    }
    
    @IBAction func changeFoodImage(_ sender: AnyObject) {
        
        let selectImage = UIImagePickerController()
        selectImage.delegate = self
        
        selectImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        //selectImage.allowsEditing = false
        self.present(selectImage, animated: true)
    }
    
    //Select image from gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            foodImage.image = selectImage
        }
        else
        {
            //Display Error Message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //This method handles collecting information entered by the user and storing in the database
    func handleStartSelling() {
        guard let foodName = menuNameTextField.text, let foodDescription = menuDescriptionTextField.text, let price = enterPriceTextField.text, let cuisine = cuisineTypeLabel.text else {
            print("Data filled is incorrect")
            return
        }
        let ref = FIRDatabase.database().reference().child("chef")
        let childRef = ref.childByAutoId()
        //Add user id
       // let toID = user!.id!
        let values = ["food": foodName, "description": foodDescription, "price": "$" + price, "cuisine": cuisine] as [String : Any]
        childRef.updateChildValues(values) { (err, ref) in
            
            if err != nil {
                print (err as Any)
                return
            }
            print ("User stored in database")
        }
        
        print("User information input in database")
    }

    override func viewDidLoad() {
    super.viewDidLoad()
        cuisineTypePickerView.delegate = self
        cuisineTypePickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        //navigationItem.title = "Start Selling"
    }
    //Call a new class to instantiate method
    //var profileController: BeforeStartSellingViewController?
    
    func goBackToStartSelling() {
        let storyboard = UIStoryboard(name: "startSelling", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BeforeSellingPage") as UIViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

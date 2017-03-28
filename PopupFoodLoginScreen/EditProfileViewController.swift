//
//  EditProfileViewController.swift
//  PopupFood
//
//  Created by Barbara Akaeze on 2017-02-27.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var profilePageController: ProfileViewController?
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var updateProfileImage: UIImageView!
 
    var databaseRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    //Change Image button
    @IBAction func changeImage(_ sender: Any) {
        
        let selectImage = UIImagePickerController()
        selectImage.delegate = self
        
        selectImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        //selectImage.allowsEditing = false
        self.present(selectImage, animated: true)

    }
    
    //Save Edited info button
    @IBAction func saveProfile(_ sender: Any) {
        updateProfile()
        profilePageController?.returnHomePage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
        loadProfileData()
    }
    
    //Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            updateProfileImage.image = selectImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //Inputs existing info from DB in the text label
    //BARBARA: Uplaoded today
    func loadProfileData() {
        
        if let userID = FIRAuth.auth()?.currentUser?.uid{
            databaseRef.child("user").child(userID).observe(.value, with: { (snapshot) in
                
                //Store users data in dictionary
                let values = snapshot.value as? NSDictionary
                
                // If there is a profile image url, load it
                if let ProfileImageURL = values?["photo"] as? String {
                    //load the photo from ImageViewer id
                    self.updateProfileImage.sd_setImage(with: URL(string: ProfileImageURL))
                }else {
                    self.updateProfileImage.image = UIImage (named: "defaultImage")
                }
                //self.updateProfileImage.image = values?["photo"]as? UIImage
                ///////////////////
                self.usernameText.text = values?["name"] as? String
                self.emailText.text = values?["email"] as? String
                self.passwordText.text = values?["password"] as? String
            })
        }
    }

    //Update the text label and image to be sent into DB
    func updateProfile() {
        //check if user is logged in
        if let userID = FIRAuth.auth()?.currentUser?.uid
        {
            //get access to user profile pic storage
            let storageItem = storageRef.child("profile_photo").child(userID)
            //get image from gallery
            guard let image = updateProfileImage.image else{
                    return
            }
            if let newImage = UIImagePNGRepresentation(image){
                //upload to Firebase storage
                storageItem.put(newImage, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    storageItem.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        if let ProfileImageURL = url?.absoluteString{
                            guard let newName = self.usernameText.text, let newEmail = self.emailText.text, let newPassword = self.passwordText.text else {
                                return
                            }
                            //save in new entry in object
                            let newValuesForProfile = ["photo": ProfileImageURL, "name": newName, "email": newEmail, "password": newPassword]
                            
                            //Update the Database
                            self.databaseRef.child("user").child(userID).updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
                                if error != nil {
                                    print(error!)
                                    return
                                }
                            })
                        }
                    })
                })
            }
        }
    }
}

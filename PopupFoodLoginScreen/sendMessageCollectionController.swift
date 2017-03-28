//
//  sendMessageCollectionController.swift
//  PopupFood
//
//  Created by Anita on 2017-03-17.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "Cell"

class sendMessageCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var messageTextField: UITextField!
    
    var menu: Menu? {
        didSet{

        }
    }
    
    @IBAction func sendButton(_ sender: Any) {
        handleSend()
    }
    
    var cellId = "cell"
    
    var sentMessages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
        // Register cell classes
        self.collectionView!.register(chatMessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    func retrieveMessagesFromDatabase() {
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return sentMessages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! chatMessageCell
        
        let messages = sentMessages[indexPath.item]
        cell.messageLabel.text = messages.text

        if let foodImageUrl = menu?.foodImageUrl {
            cell.foodImage.sd_setImage(with: URL(string: foodImageUrl))
        } else {
            cell.foodImage.image = UIImage(named: "test_pizza")
        }
        
        if let foodName = menu?.food {
            cell.foodName.text = foodName
        }
        
        return cell
    }
    
    func handleSend() {
        guard let sendMesageTextField = messageTextField.text else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let values = ["text": sendMesageTextField]
        childRef.updateChildValues(values)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}

//
//  Video Cell.swift
//  PopupFood
//
//  Created by Anita on 2017-02-09.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

//Implement Class for Video Cell
class VideoCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    //ADD SEPARATOR LINES BETWEEN CELLS
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    //IMPLEMENT BIG IMAGE DISPLAY
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "test_pizza")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //IMPLEMENT PROFILE IMAGE VIEW
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "testprofileimage_buddy")
        imageView.layer.cornerRadius = 22        //Make profile image circular (to calculate the corner radius, it is half of the height)
        imageView.layer.masksToBounds = true     //Make profile image circular
        return imageView
    }()
    
    //IMPLEMENT FAVE IMAGE VIEW
//    let faveButton: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "open_heart")
//        imageView.layer.cornerRadius = 22        //Make profile image circular (to calculate the corner radius, it is half of the height)
//        imageView.layer.masksToBounds = true     //Make profile image circular
//        return imageView
//    }()
    
    //IMPLEMENT TITLE VIEW FOR BIG IMAGE
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "Best Pizza in Kitchener"
        return label
    }()
    
    //IMPLEMENT SUBTITLE LABEL
    let subtitleLabelTextview: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        //textView.text = "Pizza Boss"
        textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0) //Remove text spacing above label
        textView.textColor = UIColor.red
        return textView
    }()

    
    func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
       // addSubview(faveButton)
        addSubview(titleLabel)
        addSubview(subtitleLabelTextview)
        
        //Specify Constraints for image cell
        addConstraintsWithFormat(format:"H:|-16-[v0]-16-|", views: thumbnailImageView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        
       // addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: faveButton)
        
        ///CONSTRAINTS FOR TEXT LABEL
        //Specify Vertical Constraints
        addConstraintsWithFormat(format:"V:|-16-[v0]-8-[v1(44)]-16-[v2(1)]|", views: thumbnailImageView, userProfileImageView, separatorView)
        
        //constraints for lines between cells
        addConstraintsWithFormat(format:"H:|[v0]|", views: separatorView)
        //Top Constraints for titleLabel; Constraint declares that title label is underneath the thumbnail (big image) by 8px
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal , toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        //Left Constraint for Title bar
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal , toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        //Right Constraint for Title bar
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal , toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        //Height constraint for Title bar
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal , toItem: self, attribute: .height, multiplier: 0, constant: 20))
        
        ///CONSTRAINTS FOR SUBTITLE TEXT
        //Top Constraints for subtitle; Constraint declares that title label is underneath the thumbnail (big image) by 8px
        addConstraint(NSLayoutConstraint(item: subtitleLabelTextview, attribute: .top, relatedBy: .equal , toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        //Left Constraint for subtitle bar
        addConstraint(NSLayoutConstraint(item: subtitleLabelTextview, attribute: .left, relatedBy: .equal , toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        //Right Constraint for subtitle bar
        addConstraint(NSLayoutConstraint(item: subtitleLabelTextview, attribute: .right, relatedBy: .equal , toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        //Height constraint for subtitle bar
        addConstraint(NSLayoutConstraint(item: subtitleLabelTextview, attribute: .height, relatedBy: .equal , toItem: self, attribute: .height, multiplier: 0, constant: 30))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




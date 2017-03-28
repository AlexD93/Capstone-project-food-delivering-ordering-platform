//
//  MenuBar.swift
//  PopupFood
//
//  Created by Student on 2017-02-11.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let imageNames = ["home", "favorites", "Messages", "selling"]
    
    //instantiate class to call navigation button
    var homeController: HomeAfterSignIn?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        //Add cell for adding icons
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        //Add white line to show selected
        setUpHorizontalBar()
        
        //ensure current menu position button is ALWAYS selected
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: (UICollectionViewScrollPosition.left))
    }
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    //Add white line to show selected
    func setUpHorizontalBar() {
        let horizontalBarView = UIView()
        //Set color to yellow
        //horizontalBarView.backgroundColor = UIColor(white: 1, alpha: 1)
        horizontalBarView.backgroundColor = UIColor.rgb(red: 248, green: 212, blue: 0, alpha: 1)
        //Display the bar under cells
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
         //Get the x, y, width and height axis
        //Setting the bar in the cells
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
    
        cell.tintColor = UIColor.rgb(red: 63, green: 176, blue: 172, alpha: 1) // blue colour
        
        return cell
    }
    //get frame and height of menu
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //BARBARA: Return position of item selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //get the current select cell and move cellbar on click
        let x = CGFloat(indexPath.item) * frame.width/4
        horizontalBarLeftAnchorConstraint?.constant = x
        
        //Animate cellbar to slide on click
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {self.layoutIfNeeded()}, completion: nil)
        
        if (indexPath.row == 1) {
            //menuController?.displayFavorites()
            print("selected item is:", indexPath.row)
            
            homeController?.displayAllFavorites()
       
        } else if (indexPath.row == 3) {
            homeController?.showProfile()
            
        } else{
            
            print("Other selected")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}//end of MenuBar class

//for entering icons
class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Home")?.withRenderingMode(.alwaysTemplate) //specify the name of the photo from Assets
        iv.tintColor = UIColor.rgb(red: 63, green: 176, blue: 172, alpha: 1) //Blue Color
        return iv
    }()
    
    
    //block for hightlights
    override var isHighlighted: Bool{
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.rgb(red: 248, green: 212, blue: 0, alpha: 1) : UIColor.rgb(red: 63, green: 176, blue: 172, alpha: 1) //Blue color
        }
    }//end of is Hightlighted
    
    //when a cell is selected, a new color is put on icons
    override var isSelected: Bool{
        didSet {
            imageView.tintColor = isSelected ? UIColor.rgb(red: 248, green: 212, blue: 0, alpha: 1) : UIColor.rgb(red: 63, green: 176, blue: 172, alpha: 1)//Blue color

        }
    }//end of isSelected

        //calling from videocell
    override func setupViews(){
        super.setupViews()
        
        addSubview(imageView)
        
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        
        addConstraints([NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        
        addConstraints([NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
    }
  
}//end of Menu Cell class


class MenuItems: UIViewController {
    
}









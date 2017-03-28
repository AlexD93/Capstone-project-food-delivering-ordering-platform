//
//  DisplayMenuTableViewCell.swift
//  PopupFood
//
//  Created by Anita on 2017-02-26.
//  Copyright © 2017 Anita Conestoga. All rights reserved.
//

import UIKit

class DisplayMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

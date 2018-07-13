//
//  PlacesCell.swift
//  NoteTours
//
//  Created by NgọcAnh on 7/11/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit

class PlacesCell: UITableViewCell {

  
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

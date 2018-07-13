//
//  RegionCell.swift
//  NoteTours
//
//  Created by NgọcAnh on 7/11/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit

class RegionCell: UITableViewCell {
    
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ConvoTableViewCell.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 7/15/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit

class ConvoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

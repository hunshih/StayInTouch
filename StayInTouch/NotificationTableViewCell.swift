//
//  NotificationTableViewCell.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 5/13/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
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
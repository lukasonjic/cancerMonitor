//
//  EntryTVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 23/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class EntryTVC: UITableViewCell {

    @IBOutlet weak var warningImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

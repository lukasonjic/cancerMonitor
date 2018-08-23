//
//  ParameterTVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 24/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class ParameterTVC: UITableViewCell {
    @IBOutlet weak var paramNameLabel: UILabel!
    
    @IBOutlet weak var exclamationImageView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

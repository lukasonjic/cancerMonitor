//
//  PatientTVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 28/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class PatientTVC: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCell()
    }

    func setupCell() {
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width/2
    }
    
}

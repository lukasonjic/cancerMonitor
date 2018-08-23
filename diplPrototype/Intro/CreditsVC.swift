//
//  CreditsVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 28/06/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class CreditsVC: UIViewController {
    @IBOutlet weak var creditsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Prijava"
        self.title = "O aplikaciji"
        self.creditsLabel.text = Constants.credits
    }

}

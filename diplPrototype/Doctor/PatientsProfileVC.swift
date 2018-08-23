//
//  PatientsProfileVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 28/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class PatientsProfileVC: UIViewController {
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var radiationTherapyLabel: UILabel!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var cancerTypeLabel: UILabel!
    @IBOutlet weak var closeImageView: UIImageView!
    
    var patient: Patient = Patient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setView()
    }
    
    func setView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(PatientsProfileVC.close))
        self.closeImageView.addGestureRecognizer(tap)
        self.closeImageView.isUserInteractionEnabled = true
        
        self.genderImageView.clipsToBounds = true
        self.genderImageView.layer.cornerRadius = self.genderImageView.frame.width/2
        
        self.nameLabel.text = patient.firstName! + " " + patient.lastName!
        self.dobLabel.text = patient.dateOfBirth
        self.emailLabel.text = patient.email
        if patient.gender == "m" {
            self.genderImageView.backgroundColor = Constants.maleColor
            self.genderImageView.image = #imageLiteral(resourceName: "boy-4")
        } else {
            self.genderImageView.image = #imageLiteral(resourceName: "girl-3")
            self.genderImageView.backgroundColor = Constants.femaleColor
        }
        self.radiationTherapyLabel.text = patient.radiationTherapy?.capitalized
        self.operationLabel.text = patient.operation?.capitalized
        self.cancerTypeLabel.text = patient.cancerType?.capitalized
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }



}

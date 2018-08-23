//
//  DoctorsProfileVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 20/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class DoctorsProfileVC: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var workplaceLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
    @IBOutlet weak var doctorImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setupView() {
        let patient = CancerMonitorUserDefaults.sharedInstance.getPatient()
        APIService.shared.getMyDoctor(email: patient.doctorsEmail!, completion: {
            (response) in
            switch response {
            case .error(_, _):
                self.showError()
            case .success(let json):
                self.emailLabel.text = json[0]["email"].string
                self.phoneLabel.text = json[0]["phoneNumber"].string
                self.nameLabel.text = json[0]["firstName"].string! + " " + json[0]["lastName"].string!
                self.workplaceLabel.text = json[0]["workplace"].string
                let date = json[0]["dateOfBirth"].string
                let substr = date?.split(separator: "T")
                if let str = substr?.first {
                    self.dobLabel.text = String(str)
                }
                self.workingHoursLabel.text = json[0]["openingHour"].string! + " - " + json[0]["closingHour"].string!
                if json[0]["gender"].string! == "f" {
                    self.doctorImageView.image = #imageLiteral(resourceName: "doctor-2")
                } else {
                    self.doctorImageView.image = #imageLiteral(resourceName: "doctor")
                }
            }
        })
    }
    
    func showError() {
        print("Neuspješno dohvaćanje profila Vašeg liječnika.")
        let alert = UIAlertController(title: "Pogreška", message: "Neuspješno dohvaćanje profila Vašeg liječnika.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

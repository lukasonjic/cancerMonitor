//
//  DoctorMyProfileVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 28/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class DoctorMyProfileVC: UIViewController {
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var workplaceLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
    
    var doctor: Doctor = Doctor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.doctor = CancerMonitorUserDefaults.sharedInstance.getDoctor()
        self.setView()
    }
    
    func setView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(DoctorMyProfileVC.logout))
        self.settingsImageView.addGestureRecognizer(tap)
        self.settingsImageView.isUserInteractionEnabled = true
        
        self.emailLabel.text = doctor.email
        self.phoneNumberLabel.text = doctor.phoneNumber
        self.nameLabel.text = doctor.firstName! + " " + doctor.lastName!
        self.workplaceLabel.text = doctor.workplace
        let date = doctor.dateOfBirth
        let substr = date?.split(separator: "T")
        if let str = substr?.first {
            self.dobLabel.text = String(str)
        }
        self.workingHoursLabel.text = doctor.openingHour! + " - " + doctor.closingHour!
        if doctor.gender == "f" {
            self.genderImageView.image = #imageLiteral(resourceName: "doctor-2")
        } else {
            self.genderImageView.image = #imageLiteral(resourceName: "doctor")
        }
    }
    
    @objc func logout() {
        let alert = UIAlertController(title: "Odjava", message: "Jeste li sigurni da se želite odjaviti?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Da", style: .default, handler: {
            (_) in
            CancerMonitorUserDefaults.sharedInstance.cleanLogout()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.present(vc!, animated: false, completion: nil)
            })
        }))
        alert.addAction(UIAlertAction(title: "Ne", style: .cancel, handler: { (_) in
            alert.dismiss(animated: false, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

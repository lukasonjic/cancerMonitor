//
//  MyProfileVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 21/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController {

    @IBOutlet weak var changeOperationButton: UIButton!
    @IBOutlet weak var alarmPicker: UIDatePicker!
    @IBOutlet weak var changeAlarmTimeButton: UIButton!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var changeRadiationButton: UIButton!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var radiationTherapyLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var settingsImageView: UIImageView!
    
    var wasChange: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if wasChange {
            self.modifyMe()
        }
        wasChange = false
    }

    
    
    func setView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MyProfileVC.logout))
        self.settingsImageView.addGestureRecognizer(tap)
        self.settingsImageView.isUserInteractionEnabled = true

        
        self.genderImageView.clipsToBounds = true
        self.genderImageView.layer.cornerRadius = self.genderImageView.frame.width/2
        self.changeAlarmTimeButton.layer.cornerRadius = 10
        self.changeRadiationButton.layer.cornerRadius = 10
        self.changeOperationButton.layer.cornerRadius = 10
        self.changeAlarmTimeButton.clipsToBounds = true
        self.alarmTimeLabel.text = "\(CancerMonitorUserDefaults.sharedInstance.getHour()):00"
        let patient = CancerMonitorUserDefaults.sharedInstance.getPatient()
        print(patient)
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
        self.alarmPicker.isHidden = true
    }

    
    @IBAction func changeRadiation(_ sender: Any) {
        if radiationTherapyLabel.text == "Da" {
            radiationTherapyLabel.text = "Ne"
            CancerMonitorUserDefaults.sharedInstance.setRadiation("ne")
        } else {
            radiationTherapyLabel.text = "Da"
            CancerMonitorUserDefaults.sharedInstance.setRadiation("da")
        }
        self.wasChange = true
    }
    
    @IBAction func changeOperation(_ sender: Any) {
        if operationLabel.text == "Da" {
            operationLabel.text = "Ne"
            CancerMonitorUserDefaults.sharedInstance.setOperation("ne")
        } else {
            operationLabel.text = "Da"
            CancerMonitorUserDefaults.sharedInstance.setOperation("da")
        }
        self.wasChange = true
    }
    
    @IBAction func changeAlarmTime(_ sender: Any) {
        if alarmPicker.isHidden {
            alarmPicker.isHidden = false
            self.changeAlarmTimeButton.setTitle("OK", for: .normal)
        } else {
            self.alarmPicker.isHidden = true
            self.changeAlarmTimeButton.setTitle("Promijeni vrijeme alarma", for: .normal)
            let time = self.alarmPicker.date
            let components = Calendar.current.dateComponents([.hour], from: time)
            Notifications.shared.changeTime(hour: components.hour!)
            self.alarmTimeLabel.text = "\(components.hour!):00"
            CancerMonitorUserDefaults.sharedInstance.setHour(hour: components.hour!)
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
    
    func modifyMe() {
        APIService.shared.updateMe(completion: {
            (response) in
            switch response {
            case .success(_):
                print("Uspješno osvježeni podaci na bazi.")
            case .error(_, _):
                print("Greška.")
            }
        })
    }
}

//
//  PatientsVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 27/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit
import SwiftyJSON

class PatientsVC: UIViewController {
    
    @IBOutlet weak var patientsTableView: UITableView!
    
    var doctor = Doctor()
    var patients: [Patient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doctor = CancerMonitorUserDefaults.sharedInstance.getDoctor()
        
        self.setTableView()
        self.getPatients()
    }

    func setTableView(){
        self.patientsTableView.delegate = self
        self.patientsTableView.dataSource = self
        self.patientsTableView.register(UINib.init(nibName: "PatientTVC", bundle: nil), forCellReuseIdentifier: "PatientTVC")
    }
    
    func getPatients() {
        APIService.shared.getMyPatients(email: self.doctor.email!) {
            (response) in
            switch response{
            case .error(_, _):
                print("error")
            case .success(let json):
                self.setPatients(json: json)
            }
        }
    }
    
    func setPatients(json: JSON){
        for js in json {
            var patient = Patient()
            patient.firstName = js.1.dictionaryValue["firstName"]?.stringValue
            patient.lastName = js.1.dictionaryValue["lastName"]?.stringValue
            patient.email = js.1.dictionaryValue["email"]?.stringValue
            patient.operation = js.1.dictionaryValue["operation"]?.stringValue
            patient.radiationTherapy = js.1.dictionaryValue["radiationTherapy"]?.stringValue
            patient.gender = js.1.dictionaryValue["gender"]?.stringValue
            patient.cancerType = js.1.dictionaryValue["cancerType"]?.stringValue
            patient.doctorsEmail = doctor.email
            let substr = js.1.dictionaryValue["dateOfBirth"]?.string!.split(separator: "T")
            if let str = substr?.first {
                patient.dateOfBirth = String(str)
            }
            self.patients.append(patient)
        }
        self.patientsTableView.reloadData()
        
    }
}

extension PatientsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if patients.count > 0 {
            return patients.count
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientTVC") as! PatientTVC
        if patients.count > 0 {
            cell.nameLabel.text = patients[indexPath.row].firstName! + " " + patients[indexPath.row].lastName!
            if patients[indexPath.row].gender == "m" {
                cell.userImageView.image = #imageLiteral(resourceName: "boy-4")
                cell.userImageView.backgroundColor = Constants.maleColor
            } else {
                cell.userImageView.image = #imageLiteral(resourceName: "girl-3")
                cell.userImageView.backgroundColor = Constants.femaleColor
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Doctor", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PatientsProfileVC") as? PatientsProfileVC {
            vc.patient = patients[indexPath.row]
            self.present(vc, animated: true, completion: nil)
        }
    }
}



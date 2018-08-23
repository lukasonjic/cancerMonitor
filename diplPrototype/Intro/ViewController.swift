//
//  ViewController.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 04/04/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var registerTextLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var boxingXConstraint: NSLayoutConstraint!
    
    var loginClicked: Bool = false
    var submitvc: SetupEmailForSubmit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupView()
        self.setTextFieldDelegate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setTextFieldDelegate(){
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.boxingXConstraint.constant = -40
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.switchTo()
    }
    
    func switchTo() {
        if Reachability.isConnectedToNetwork(){
            if CancerMonitorUserDefaults.sharedInstance.getMyToken() != nil {
                if CancerMonitorUserDefaults.sharedInstance.isDoctor() {
                    self.navigateTo(0)
                } else {
                    self.navigateTo(1)
                }
            }
        } else {
            let alert = UIAlertController.init(title: "Nema internetske veze", message: "Molimo Vas uključite mobilne podatke ili se spojite na Wifi te ponovno pokrenite aplikaciju.", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: {
                (_) in
                exit(0)
            }))
        }
        
    }
    
    func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.showCredits))
        self.infoImageView.addGestureRecognizer(tap)
        self.infoImageView.isUserInteractionEnabled = true
        
        self.hideKeyboard()
        self.passwordErrorLabel.isHidden = true
        
        self.signInButton.layer.cornerRadius = 10
        self.signInButton.clipsToBounds = true
        
        self.registerButton.layer.cornerRadius = 10
        self.registerButton.clipsToBounds = true
        
        self.passwordTextField.isSecureTextEntry = true
    }

    @IBAction func login(_ sender: Any) {
        loginClicked = true
        if emailTextField.text != nil && emailTextField.text!.count > 0 {
            guard emailTextField.text!.isValidEmail() else {
                let alert = UIAlertController(title: "Pogreška", message: "Email nije ispravan. Molimo Vas provjerite mail i pokušajte ponovno.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            if passwordTextField.text != nil && passwordTextField.text!.count > 0 {
                if passwordTextField.text!.count < 6 {
                    print("Lozinka prekratka")
                    let alert = UIAlertController(title: "Pogreška", message: "Lozinka je prekratka. Mora biti dulja od 6 znakova.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    passwordTextField.text = ""
                    return
                } else {
                    APIService.shared.login(emailTextField.text!, password: passwordTextField.text!) {
                        (response) in
                        switch response{
                        case .success(let result):
                            if result != .null {
                                if let amDoctor = Bool((result.dictionaryValue["doctor"]?.string)!) {
                                    if amDoctor {
                                        CancerMonitorUserDefaults.sharedInstance.setToken(token: (result.dictionaryValue["token"]?.string)!, isDoctor: true)
                                        self.navigateTo(0)
                                    } else {
                                        CancerMonitorUserDefaults.sharedInstance.setToken(token: (result.dictionaryValue["token"]?.string)!, isDoctor: false)
                                        self.navigateTo(1)
                                    }
                                }
                            }
                        case .error(let title, let message):
                            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func register(_ sender: Any) {
        let vc = ViewController.mainStoryboard.instantiateViewController(withIdentifier: "RegisterTVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showCredits(){
        let vc = ViewController.mainStoryboard.instantiateViewController(withIdentifier: "CreditsVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func getAndSetPatient(){
        print(emailTextField.text!)
        APIService.shared.getPatient(email: emailTextField.text!) {
            (response) in
            switch response {
            case .success(let json):
                var patient = Patient()
                patient.email = (json[0]["email"].string)!
                patient.operation = (json[0]["operation"].string)!
                patient.radiationTherapy = (json[0]["radiationTherapy"].string)!
                patient.gender = (json[0]["gender"].string)!
                patient.firstName = (json[0]["firstName"].string)!
                patient.lastName = (json[0]["lastName"].string)!
                patient.cancerType = (json[0]["cancerType"].string)!
                let substr = (json[0]["dateOfBirth"].string)!.split(separator: "T")
                if let str = substr.first {
                   patient.dateOfBirth = String(str)
                }
                self.setPatient(patient: patient)
            case .error(_, _):
                break
            }
        }
    }
    
    func getAndSetDoctor(){
        print(emailTextField.text!)
        APIService.shared.getMyDoctor(email: emailTextField.text!) {
            (response) in
            switch response {
            case .success(let json):
                var doctor = Doctor()
                doctor.email = (json[0]["email"].string)!
                doctor.openingHour = (json[0]["openingHour"].string)!
                doctor.closingHour = (json[0]["closingHour"].string)!
                doctor.gender = (json[0]["gender"].string)!
                doctor.firstName = (json[0]["firstName"].string)!
                doctor.lastName = (json[0]["lastName"].string)!
                doctor.workplace = (json[0]["workplace"].string)!
                doctor.phoneNumber = (json[0]["phoneNumber"].string)!
                let substr = (json[0]["dateOfBirth"].string)!.split(separator: "T")
                if let str = substr.first {
                    doctor.dateOfBirth = String(str)
                }
                self.setDoctor(doctor: doctor)
            case .error(_, _):
                break
            }
        }
    }
    
    func setPatient(patient: Patient){
        APIService.shared.getDoctorByMyEmail(email: patient.email!) {
            (response) in
            switch response{
            case .error(_, _):
                print("greška")
            case .success(let json):
                var pat = patient
                pat.doctorsEmail = json[0]["emailDoctor"].string
                print(pat)
                CancerMonitorUserDefaults.sharedInstance.setPatient(patient: pat)
            }
        }
        
    }
    
    func setDoctor(doctor: Doctor){
        CancerMonitorUserDefaults.sharedInstance.setDoctor(doctor: doctor)
    }
    
    func navigateTo(_ code: Int) {
        var name = ""
        switch code {
        case 0:
            name = "Doctor"
            if loginClicked {
                self.getAndSetDoctor()
            }
        case 1:
            name = "Patient"
            if loginClicked {
                self.getAndSetPatient()
            }
            
        default:
            break
        }
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let secondViewController = storyboard.instantiateInitialViewController() as? UITabBarController {
            if let vc = secondViewController.viewControllers?.first as? SubmitTodayVC {
                vc.email = loginClicked ? self.emailTextField.text! : CancerMonitorUserDefaults.sharedInstance.getMyEmail()
            }
            if let vc = secondViewController.viewControllers?.first as? ViewPatientsStateVC {
                vc.email = loginClicked ? self.emailTextField.text! : CancerMonitorUserDefaults.sharedInstance.getMyEmail()
            }
            self.present(secondViewController, animated: false, completion: nil)
        }
        
    
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

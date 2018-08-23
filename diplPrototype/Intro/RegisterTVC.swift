//
//  RegisterTVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 19/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class RegisterTVC: UITableViewController {
    @IBOutlet weak var cancerTypePickerView: UIPickerView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var operationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var radiationTherapySegmentedControl: UISegmentedControl!
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var doctorsEmailTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Prijava"
        self.title = "Registracija"
        
        setPicker()
        self.registerButton.clipsToBounds = true
        self.registerButton.layer.cornerRadius = 10
        self.passwordTextField.isSecureTextEntry = true
        setTextFieldDelegate()
    }
    
    func setPicker(){
        self.cancerTypePickerView.dataSource = self
        self.cancerTypePickerView.delegate = self
    }
    
    func setTextFieldDelegate(){
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.doctorsEmailTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
    }
    
    @IBAction func register(_ sender: Any) {
        if emailTextField.text!.count == 0 || passwordTextField.text!.count == 0 || doctorsEmailTextField.text!.count == 0 || firstNameTextField.text!.count == 0 || lastNameTextField.text!.count == 0 {
            showEmptyFields()
            return
        }
        guard emailTextField.text!.isValidEmail() else {
            showWrongEmail()
            return
        }
        guard doctorsEmailTextField.text!.isValidEmail() else {
            showWrongDoctorsEmail()
            return
        }
        if passwordTextField.text!.count < 6 {
            showTooShortPassword()
            passwordTextField.text = ""
            return
        }
        //try to register
        if !register() {
            print("Could not register.")
        }
    }
    
    func showEmptyFields() {
        let alert = UIAlertController(title: "Pogreška", message: "Sva polja za unos moraju biti popunjena.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showWrongEmail() {
        let alert = UIAlertController(title: "Pogreška", message: "Email nije ispravan. Molimo Vas provjerite mail i pokušajte ponovno.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showWrongDoctorsEmail() {
        let alert = UIAlertController(title: "Pogreška", message: "Email liječnika nije ispravan. Molimo Vas provjerite mail i pokušajte ponovno.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showTooShortPassword() {
        print("Lozinka prekratka")
        let alert = UIAlertController(title: "Pogreška", message: "Lozinka je prekratka. Mora biti dulja od 6 znakova.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(message: String) {
        print("Neuspješna registracija.")
        let alert = UIAlertController(title: "Pogreška", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func register() -> Bool {
        APIService.shared.register(email: emailTextField.text!, emailDoctor: doctorsEmailTextField.text!, password: passwordTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, dob: dobPicker.date, gender: gender.selectedSegmentIndex, cancerType: cancerTypePickerView.selectedRow(inComponent: 0), radiationTherapy: radiationTherapySegmentedControl.selectedSegmentIndex, operation: operationSegmentedControl.selectedSegmentIndex, completion: {
            (response) in
            switch response{
            case .success:
                self.navigateToPatient()
            case .error(_, let msg):
                self.showError(message: msg)
            }
        })
        return true
    }
    
    func navigateToPatient() {
        let storyboard = UIStoryboard(name: "Patient", bundle: nil)
        let secondViewController = storyboard.instantiateInitialViewController()!
        
        self.present(secondViewController, animated: false, completion: nil)
    }
    
}

extension RegisterTVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.cancerTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.cancerTypes[row]
    }
}

extension RegisterTVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}

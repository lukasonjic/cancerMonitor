//
//  TemperatureVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 25/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class TemperatureVC: UIViewController {
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var nauseaPicker: UIPickerView!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var vomitingPicker: UIPickerView!
    @IBOutlet weak var noOfVomitingsSlider: UISlider!
    @IBOutlet weak var noOfVomitingsLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nextImageView: UIImageView!
    
    var entry = Entry()
    var canEdit = false
    var shouldBeDismissed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPickers()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldBeDismissed {
            self.dismiss(animated: false, completion: nil)
        }
        
        if entry.temperature != nil {
            setViewWithValues()
            canEdit = true
        }
    }
    
    func setPickers(){
        self.nauseaPicker.dataSource = self
        self.vomitingPicker.dataSource = self
        self.vomitingPicker.delegate = self
        self.nauseaPicker.delegate = self
    }
    
    func setView() {
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TemperatureVC.close))
        closeImageView.addGestureRecognizer(tap)
        closeImageView.isUserInteractionEnabled = true
        
        let tapNext = UITapGestureRecognizer(target: self, action: #selector(TemperatureVC.tappedNext))
        nextImageView.addGestureRecognizer(tapNext)
        nextImageView.isUserInteractionEnabled = true
        
        self.closeImageView.layer.cornerRadius = self.closeImageView.frame.width/2
        self.closeImageView.clipsToBounds = true
        self.closeImageView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 15
        self.nextImageView.layer.cornerRadius = self.nextImageView.frame.width/2
    }
    
    func setViewWithValues() {
        self.temperatureSlider.value = Float(entry.temperature!)
        self.noOfVomitingsSlider.value = Float(entry.noOfVomitings!)
        let temp = entry.temperature!.rounded(toPlaces: 1)
        self.temperatureLabel.text = "Temperatura - " + String(temp)
        let number = entry.noOfVomitings!
        if number == 5 {
            self.noOfVomitingsLabel.text = "Broj epizoda povraćanja - " + String(number) + "+"
        } else {
            self.noOfVomitingsLabel.text = "Broj epizoda povraćanja - " + String(number)
        }
        switch entry.nausea! {
        case "nema":
            self.nauseaPicker.selectRow(0, inComponent: 0, animated: false)
        case "jutarnja":
            self.nauseaPicker.selectRow(1, inComponent: 0, animated: false)
        case "nakon jela":
            self.nauseaPicker.selectRow(2, inComponent: 0, animated: false)
        case "stalna":
            self.nauseaPicker.selectRow(3, inComponent: 0, animated: false)
        default:
            break
        }
        
        switch entry.vomiting! {
        case "ne":
            self.vomitingPicker.selectRow(0, inComponent: 0, animated: false)
        case "jednom":
            self.vomitingPicker.selectRow(1, inComponent: 0, animated: false)
        case "jednom, nakon jela":
            self.vomitingPicker.selectRow(2, inComponent: 0, animated: false)
        case "u više navrata":
            self.vomitingPicker.selectRow(3, inComponent: 0, animated: false)
        default:
            break
        }
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedNext(){
        self.entry.temperature = Double(self.temperatureSlider.value).rounded(toPlaces: 1)
        self.entry.nausea = Constants.nausea[self.nauseaPicker.selectedRow(inComponent: 0)]
        self.entry.vomiting = Constants.vomiting[self.vomitingPicker.selectedRow(inComponent: 0)]
        self.entry.noOfVomitings = Int(self.noOfVomitingsSlider.value)
        let storyboard = UIStoryboard.init(name: "Patient", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "MucositisVC") as? MucositisVC {
            vc.entry = self.entry
            vc.dismissToBack = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func temperatureChanged(_ sender: Any) {
        let value = Double(self.temperatureSlider.value).rounded(toPlaces: 1)
        self.temperatureLabel.text = "Temperatura - " + String(value)
        
    }
    
    @IBAction func noOfVomitingsChanged(_ sender: Any) {
        let value = Int(self.noOfVomitingsSlider.value)
        if value == 5 {
            self.noOfVomitingsLabel.text = "Broj epizoda povraćanja - " + String(value) + "+"
        } else {
            self.noOfVomitingsLabel.text = "Broj epizoda povraćanja - " + String(value)
        }
    }
}

extension TemperatureVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == vomitingPicker {
            return Constants.vomiting.count
        } else if pickerView == nauseaPicker {
            return Constants.nausea.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == vomitingPicker {
            return Constants.vomiting[row]
        } else if pickerView == nauseaPicker {
            return Constants.nausea[row]
        }
        return "placeholder"
    }
}

extension TemperatureVC: TemperatureShouldBeDismissed {
    func setDismiss() {
        self.shouldBeDismissed = true
    }
}

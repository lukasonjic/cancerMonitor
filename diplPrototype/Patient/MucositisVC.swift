//
//  MucositisVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 25/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class MucositisVC: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var mucositisPicker: UIPickerView!
    @IBOutlet weak var lossOfApetiteSwitch: UISwitch!
    @IBOutlet weak var changeOfTasteSwitch: UISwitch!
    @IBOutlet weak var urinalProblemsSwitch: UISwitch!
    @IBOutlet weak var constipationSwitch: UISwitch!
    @IBOutlet weak var diarrheaSwitch: UISwitch!
    @IBOutlet weak var bleedingSwitch: UISwitch!
   
    var entry = Entry()
    var canEdit = false
    var shouldBeDismissed = false
    var dismissToBack: TemperatureShouldBeDismissed?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setPicker()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldBeDismissed {
            self.dismissToBack?.setDismiss()
            self.dismiss(animated: false, completion: nil)
        }
        
        if entry.mucositis != nil {
            self.setViewWithValues()
            self.canEdit = true
        }
    }
    
    func setView() {
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MucositisVC.close))
        closeImageView.addGestureRecognizer(tap)
        closeImageView.isUserInteractionEnabled = true
        
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(MucositisVC.tappedBack))
        backImageView.addGestureRecognizer(tapBack)
        backImageView.isUserInteractionEnabled = true
        
        let tapNext = UITapGestureRecognizer(target: self, action: #selector(MucositisVC.tappedNext))
        nextImageView.addGestureRecognizer(tapNext)
        nextImageView.isUserInteractionEnabled = true
        
        self.closeImageView.layer.cornerRadius = self.closeImageView.frame.width/2
        self.closeImageView.clipsToBounds = true
        self.closeImageView.backgroundColor = UIColor.white

        self.contentView.layer.cornerRadius = 15
        self.nextImageView.layer.cornerRadius = self.nextImageView.frame.width/2
        self.backImageView.layer.cornerRadius = self.backImageView.frame.width/2
    }

    func setViewWithValues() {
        switch entry.mucositis! {
        case "ne":
            self.mucositisPicker.selectRow(0, inComponent: 0, animated: false)
        case "blagi":
            self.mucositisPicker.selectRow(1, inComponent: 0, animated: false)
        case "srednji":
            self.mucositisPicker.selectRow(2, inComponent: 0, animated: false)
        case "teški":
            self.mucositisPicker.selectRow(3, inComponent: 0, animated: false)
        default:
            break
        }
        if entry.lossOfApetite == "da" {
            self.lossOfApetiteSwitch.setOn(true, animated: false)
        }
        if entry.changeOfTaste == "da" {
            self.changeOfTasteSwitch.setOn(true, animated: false)
        }
        if entry.diarrhea == "da" {
            self.diarrheaSwitch.setOn(true, animated: false)
        }
        if entry.constipation == "da" {
            self.constipationSwitch.setOn(true, animated: false)
        }
        if entry.urinalProblems == "da" {
            self.urinalProblemsSwitch.setOn(true, animated: false)
        }
        if entry.bleeding == "da" {
            self.bleedingSwitch.setOn(true, animated: false)
        }
    }
    
    func setPicker(){
        self.mucositisPicker.dataSource = self
        self.mucositisPicker.delegate = self
    }

    @objc func close() {
        self.dismissToBack?.setDismiss()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedNext(){
        self.entry.mucositis = Constants.mucositis[self.mucositisPicker.selectedRow(inComponent: 0)]
        self.entry.bleeding = self.bleedingSwitch.isOn ? "da" : "ne"
        self.entry.lossOfApetite = self.lossOfApetiteSwitch.isOn ? "da" : "ne"
        self.entry.changeOfTaste = self.changeOfTasteSwitch.isOn ? "da" : "ne"
        self.entry.diarrhea = self.diarrheaSwitch.isOn ? "da" : "ne"
        self.entry.constipation = self.constipationSwitch.isOn ? "da" : "ne"
        self.entry.urinalProblems = self.urinalProblemsSwitch.isOn ? "da" : "ne"
        let storyboard = UIStoryboard.init(name: "Patient", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "HeadacheVC") as? HeadacheVC {
            vc.entry = self.entry
            vc.dismissToBack = self
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension MucositisVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.mucositis.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.mucositis[row]
    }
}

extension MucositisVC: MucositisShouldBeDismissed {
    func setDismiss() {
        self.shouldBeDismissed = true
    }
}

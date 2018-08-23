//
//  ActivityVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 26/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class ActivityVC: UIViewController {
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var acitvityPicker: UIPickerView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    
    var entry = Entry()
    var canEdit = false
    var dismissToBack: HeadacheShouldBeDismissed?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setPicker()
        self.setTextViewDelegate()
        self.setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if entry.activity != nil {
            self.canEdit = true
            setViewWithValues()
        }
    }

    func setPicker() {
        self.acitvityPicker.delegate = self
        self.acitvityPicker.dataSource = self
    }
    
    func setTextViewDelegate(){
        self.commentTextView.delegate = self
    }
    
    func setView() {
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ActivityVC.close))
        closeImageView.addGestureRecognizer(tap)
        closeImageView.isUserInteractionEnabled = true
        
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(ActivityVC.tappedBack))
        backImageView.addGestureRecognizer(tapBack)
        backImageView.isUserInteractionEnabled = true
        
        
        self.closeImageView.layer.cornerRadius = self.closeImageView.frame.width/2
        self.closeImageView.backgroundColor = UIColor.white
        
        self.contentView.layer.cornerRadius = 15
        self.backImageView.layer.cornerRadius = self.backImageView.frame.width/2
        
        self.sendButton.layer.cornerRadius = 10
    }
    
    func setViewWithValues(){
        self.sendButton.setTitle("Promijeni unos", for: .normal)
        switch entry.activity {
        case Constants.activity[0]:
            self.acitvityPicker.selectRow(0, inComponent: 0, animated: false)
        case Constants.activity[1]:
            self.acitvityPicker.selectRow(1, inComponent: 0, animated: false)
        case Constants.activity[2]:
            self.acitvityPicker.selectRow(2, inComponent: 0, animated: false)
        case Constants.activity[3]:
            self.acitvityPicker.selectRow(3, inComponent: 0, animated: false)
        default:
            break
        }
        self.commentTextView.text = entry.comment
    }
    
    @objc func close() {
        self.dismissToBack?.setDismiss()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        self.commentTextView.endEditing(true)
        if self.commentTextView.text == "" {
            self.commentTextView.text = "Ovdje upišite komentar."
        }
    }
    
    @IBAction func submitStatus(_ sender: Any) {
        entry.activity = Constants.activity[self.acitvityPicker.selectedRow(inComponent: 0)]
        entry.comment = self.commentTextView.text == "Ovdje upišite komentar." ? "Bez komentara." : self.commentTextView.text
        if !canEdit {
            entry.entryTime = self.getEntryTime()
            APIService.shared.insertEntry(entry: self.entry) {
                (response) in
                switch response{
                case .success(_):
                    self.showSuccess(message: "Uspješan unos stanja.")
                case .error(_, _):
                    self.showError(message: "Neuspješan pokušaj unosa stanja.")
                }
            }
        } else {
            APIService.shared.updateEntry(entry: self.entry) {
                (response) in
                switch response{
                case .success(_):
                    self.showSuccessOnUpdate(message: "Uspješna promjena stanja.")
                case .error(_, _):
                    self.showError(message: "Neuspješan pokušaj promjene stanja.")
                }
            }
        }
       
        
    }
    
    func getEntryTime() -> String {
        let components = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: Date())
        var hour = 0
        switch components.hour {
        case 22:
            hour = 0
        case 23:
            hour = 1
        default:
            hour = components.hour! + 2
        }
        var str1 = ""
        if components.month! < 10 {
            str1 = String(components.year!) + "-0" + String(components.month!) + "-" + String(components.day!) + " "
        } else {
            str1 = String(components.year!) + "-" + String(components.month!) + "-" + String(components.day!) + " "
        }
        let str2 = String(hour) + ":" + String(components.minute!) + ":00"
        print(Date(), str1+str2)
        return str1+str2
    }
    
    func showError(message: String) {
        print("Neuspješan pokušaj unosa.")
        let alert = UIAlertController(title: "Pogreška", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showSuccess(message: String) {
        print("Uspješno.")
        let alert = UIAlertController(title: "Uspjeh", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (_) in
            self.dismissToBack?.setDismiss()
            self.dismiss(animated: false, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccessOnUpdate(message: String) {
        print("Uspješno.")
        let alert = UIAlertController(title: "Uspjeh", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (_) in
            self.dismissToBack?.setDismiss()
            self.dismiss(animated: false, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
    
    
}

extension ActivityVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.activity.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return Constants.activity[row]
    }
}

extension ActivityVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !canEdit {
            textView.text = nil
        }
    }
}

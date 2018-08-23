//
//  SubmitTodayVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 13/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

 import UIKit
import SwiftyJSON

class SubmitTodayVC: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var entry = Entry()
    var canEdit = false
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getEntry()
    }

    func setupView(){
        self.actionButton.layer.cornerRadius = 10
        if canEdit {
            self.textLabel.numberOfLines = 3
            self.actionButton.setTitle("Promijeni unos", for: .normal)
            self.textLabel.text = "Već ste unijeli stanje za današnji dan. Ako želite promijeniti svoj unos, pritisnite na gumb ispod."
        } else {
            self.textLabel.numberOfLines = 5
            self.actionButton.setTitle("Unesi stanje", for: .normal)
            self.textLabel.text = "Trenutno ne postoji unos za današnji dan. Molimo Vas pritisnite na gumb ispod i ispunite tražene podatke u idućim koracima."
        }
    }
 
    func getEntry() {
        APIService.shared.getEntrys(email: self.email) {
            (response) in
            switch response{
            case .error(_, _):
                print("error")
            case .success(let json):
                self.setEntry(json: json)
            }
        }
    }
    
    func setEntry(json: JSON) {
        var i = 0
        for js in json {
            if i == 0 {
                entry.diarrhea = js.1.dictionaryValue["diarrhea"]?.string!
                entry.bleeding = js.1.dictionaryValue["bleeding"]?.string!
                entry.nausea = js.1.dictionaryValue["nausea"]?.string!
                entry.comment = js.1.dictionaryValue["comment"]?.string!
                entry.temperature = js.1.dictionaryValue["temperature"]?.double!
                entry.chestPain = js.1.dictionaryValue["chestPain"]?.int!
                entry.stomachPain = js.1.dictionaryValue["stomachPain"]?.int!
                entry.headache = js.1.dictionaryValue["headache"]?.int!
                entry.changeOfTaste = js.1.dictionaryValue["changeOfTaste"]?.string!
                entry.activity = js.1.dictionaryValue["activity"]?.string!
                entry.mucositis = js.1.dictionaryValue["mucositis"]?.string!
                entry.vomiting = js.1.dictionaryValue["vomiting"]?.string!
                entry.noOfVomitings = js.1.dictionaryValue["noOfVomitings"]?.int!
                entry.urinalProblems = js.1.dictionaryValue["urinalProblems"]?.string!
                entry.constipation = js.1.dictionaryValue["constipation"]?.string!
                entry.lossOfApetite = js.1.dictionaryValue["lossOfApetite"]?.string!
                entry.entryTime = js.1.dictionaryValue["entryTime"]?.string!
                /*let substr = js.1.dictionaryValue["entryTime"]?.string!.split(separator: "T")
                if let str = substr?.first {
                    entry.entryTime = String(str)
                }*/
            } else {
                break
            }
            i += 1
        }
        self.checkIfToday()
        
    }
    
    func checkIfToday() {
        print(entry)
        let now = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        var todayStr = ""
        if now.month! < 10 {
            todayStr = String(now.year!) + "-0" + String(now.month!) + "-" + String(now.day!)
        } else {
            todayStr = String(now.year!) + "-" + String(now.month!) + "-" + String(now.day!)
        }
        let substr = entry.entryTime?.split(separator: " ")
        if let str = substr?.first {
            if todayStr == str {
                self.canEdit = true
            }
        }
        /*if let entryTime = entry.entryTime {
            if todayStr == entryTime {
                self.canEdit = true
            }
        }*/
        self.setupView()
    }

    @IBAction func clickedToEnterState(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Patient", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TemperatureVC") as? TemperatureVC {
            if canEdit {
                vc.entry = self.entry
            }
            self.tabBarController?.present(vc, animated: true, completion: nil)
            //self.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension SubmitTodayVC: SetupEmailForSubmit {
    func setEmail(email: String) {
        self.email = email
    }
    
    
}

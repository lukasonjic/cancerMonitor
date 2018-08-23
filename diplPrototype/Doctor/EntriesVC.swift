//
//  EntrysVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 28/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit
import SwiftyJSON

class EntriesVC: UIViewController {
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var entriesTableView: UITableView!
    
    
    var patientEmail: String?
    var entries: [Entry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        self.getEntries()
        self.setTableView()
    }
    
    func setUI(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(EntriesVC.close))
        self.closeImageView.addGestureRecognizer(tap)
        self.closeImageView.isUserInteractionEnabled = true
    }
    
    func getEntries() {
        APIService.shared.getEntrys(email: self.patientEmail!) {
            (response) in
            switch response{
            case .error(_, _):
                print("Error ocurred while getting entries.")
            case .success(let json):
                print("uspjeh", json)
                self.setEntries(json: json)
            }
        }
    }
    
    func setTableView(){
        self.entriesTableView.delegate = self
        self.entriesTableView.dataSource = self
        self.entriesTableView.register(UINib.init(nibName: "EntryTVC", bundle: nil), forCellReuseIdentifier: "EntryTVC")
    }
    
    func setEntries(json: JSON) {
        for js in json {
            var entry = Entry()
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
            self.entries.append(entry)
        }
        self.entriesTableView.reloadData()
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension EntriesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if entries.count > 0 {
            return entries.count
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryTVC") as! EntryTVC
        if entries.count == 0 {
            return UITableViewCell()
        } else {
            if entries[indexPath.row].numberOfBadStats() > 3 {
                cell.stateImageView.image = #imageLiteral(resourceName: "sad")
            } else {
                cell.stateImageView.image = #imageLiteral(resourceName: "smile")
            }
            if !entries[indexPath.row].shouldBeWarned() {
                cell.warningImageView.isHidden = true
            } else {
                cell.warningImageView.isHidden = false
            }
            let substr = entries[indexPath.row].entryTime?.split(separator: " ")
            if let str = substr?.first {
                cell.dateLabel.text = String(str)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Patient", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ShowEntryVC") as? ShowEntryVC {
            if indexPath.row < entries.count {
                vc.entry = self.entries[indexPath.row]
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    static var patientStoryboard: UIStoryboard {
        return UIStoryboard(name: "Patient", bundle: nil)
    }
}

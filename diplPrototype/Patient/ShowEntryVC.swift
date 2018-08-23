//
//  ShowEntryVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 24/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class ShowEntryVC: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryTableView: UITableView!

    var entry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        self.setTableView()
    }
    
    
    
    func setUI(){
        let substr = entry?.entryTime!.split(separator: " ")
        if let str = substr?.first {
            self.dateLabel.text = String(str)
        }
    }
    
    func setTableView(){
        self.entryTableView.delegate = self
        self.entryTableView.dataSource = self
        self.entryTableView.register(UINib.init(nibName: "ParameterTVC", bundle: nil), forCellReuseIdentifier: "ParameterTVC")
        self.entryTableView.register(UINib.init(nibName: "CommentTVC", bundle: nil), forCellReuseIdentifier: "CommentTVC")
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ShowEntryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ParameterTVC") as? ParameterTVC else {
            return UITableViewCell()
        }
        switch  indexPath.row {
        case 0:
            cell.paramNameLabel.text = "Temperatura"
            cell.valueLabel.text = String(entry!.temperature!)
            if entry!.temperature! > 38.0 {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 1:
            cell.paramNameLabel.text = "Mučnina"
            cell.valueLabel.text = entry?.nausea!.capitalized
            if entry!.nausea! == "stalna" {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 2:
            cell.paramNameLabel.text = "Povraćanje"
            cell.valueLabel.text = entry?.vomiting!.capitalized
            if entry?.vomiting! == "u više navrata" {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 3:
            cell.paramNameLabel.text = "Broj epizoda povraćanja"
            cell.valueLabel.text = String(entry!.noOfVomitings!)
            if entry!.noOfVomitings! > 3 {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 4:
            cell.paramNameLabel.text = "Gubitak apetita"
            cell.valueLabel.text = entry?.lossOfApetite!.capitalized
            if entry?.lossOfApetite! == "ne jede" {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 5:
            cell.paramNameLabel.text = "Promjena okusa"
            cell.valueLabel.text = entry?.changeOfTaste!.capitalized
            if entry?.changeOfTaste! == "da" {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 6:
            cell.paramNameLabel.text = "Mukozitis"
            cell.valueLabel.text = entry?.mucositis!.capitalized
            if entry?.mucositis! == "jaki" {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 7:
            cell.paramNameLabel.text = "Proljev"
            cell.valueLabel.text = entry?.diarrhea!.capitalized
            if entry?.diarrhea! == "da" {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 8:
            cell.paramNameLabel.text = "Konstipacija"
            cell.valueLabel.text = entry?.constipation!.capitalized
            if entry?.constipation! == "da" {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 9:
            cell.paramNameLabel.text = "Urinarni problemi"
            cell.valueLabel.text = entry?.urinalProblems!.capitalized
            if entry?.urinalProblems == "da" {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 10:
            cell.paramNameLabel.text = "Glavobolja"
            cell.valueLabel.text = String(entry!.headache!)
            if entry!.headache! > 6 {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 11:
            cell.paramNameLabel.text = "Bol u prsima"
            cell.valueLabel.text = String(entry!.chestPain!)
            if entry!.chestPain! > 6 {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 12:
            cell.paramNameLabel.text = "Bol u trbuhu"
            cell.valueLabel.text = String(entry!.stomachPain!)
            if entry!.stomachPain! > 6 {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 13:
            cell.paramNameLabel.text = "Krvarenje"
            cell.valueLabel.text = entry?.bleeding!.capitalized
            if entry?.bleeding == "da" {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 14:
            cell.paramNameLabel.text = "Aktivnost"
            cell.valueLabel.text = entry?.activity!
            if entry?.activity == "Skroz neaktivan." {
                cell.exclamationImageView.isHidden = false
            } else {
                cell.exclamationImageView.isHidden = true
            }
        case 15:
            let cel = tableView.dequeueReusableCell(withIdentifier: "CommentTVC") as! CommentTVC
            cel.commentLabel.text = entry?.comment!
            return cel
        default:
           return UITableViewCell()
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 15 {
            return 140
        } else {
            return 70
        }
        
    }
    
}

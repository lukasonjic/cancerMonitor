//
//  HeadacheVC.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 26/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import UIKit

class HeadacheVC: UIViewController {
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var headacheLabel: UILabel!
    @IBOutlet weak var headacheSlider: UISlider!
    @IBOutlet weak var chestPainLabel: UILabel!
    @IBOutlet weak var stomachPainLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stomachPainSlider: UISlider!
    @IBOutlet weak var chestPainSlider: UISlider!
    
    var entry = Entry()
    var canEdit = false
    var shouldBeDismissed = false
    var dismissToBack: MucositisShouldBeDismissed?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(entry)
        self.setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldBeDismissed {
            self.dismissToBack?.setDismiss()
            self.dismiss(animated: false, completion: nil)
        }
        
        if entry.headache != nil {
            self.setViewWithValues()
            self.canEdit = true
        }
    }
    
    func setView() {
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HeadacheVC.close))
        closeImageView.addGestureRecognizer(tap)
        closeImageView.isUserInteractionEnabled = true
        
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(HeadacheVC.tappedBack))
        backImageView.addGestureRecognizer(tapBack)
        backImageView.isUserInteractionEnabled = true
        
        let tapNext = UITapGestureRecognizer(target: self, action: #selector(HeadacheVC.tappedNext))
        nextImageView.addGestureRecognizer(tapNext)
        nextImageView.isUserInteractionEnabled = true
        
        self.closeImageView.layer.cornerRadius = self.closeImageView.frame.width/2
        self.closeImageView.backgroundColor = UIColor.white
        
        self.contentView.layer.cornerRadius = 15
        self.nextImageView.layer.cornerRadius = self.nextImageView.frame.width/2
        self.backImageView.layer.cornerRadius = self.backImageView.frame.width/2
    }
    
    
    func setViewWithValues(){
        self.chestPainSlider.value = Float(entry.chestPain!)
        self.stomachPainSlider.value = Float(entry.stomachPain!)
        self.headacheSlider.value = Float(entry.headache!)
        self.chestPainLabel.text =  "Bol u prsima " + String(entry.chestPain!)
        self.headacheLabel.text = "Glavobolja - " + String(entry.headache!)
        self.stomachPainLabel.text = "Bol u trbuhu " + String(entry.stomachPain!)
    }
    
    @objc func close() {
        self.dismissToBack?.setDismiss()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedNext(){
        self.entry.headache = Int(self.headacheSlider.value)
        self.entry.stomachPain = Int(self.stomachPainSlider.value)
        self.entry.chestPain = Int(self.chestPainSlider.value)
        let storyboard = UIStoryboard.init(name: "Patient", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ActivityVC") as? ActivityVC {
            vc.entry = self.entry
            vc.dismissToBack = self
            self.present(vc, animated: true, completion: nil)
        }
        print(entry, "next")
    }

    @IBAction func headacheValueChanged(_ sender: Any) {
        self.headacheLabel.text = "Glavobolja - " + String(Int(headacheSlider.value))
    }
    
    @IBAction func chestPainValueChanged(_ sender: Any) {
        self.chestPainLabel.text = "Bol u prsima - " + String(Int(chestPainSlider.value))
    }
    
    @IBAction func stomachPainValueChanged(_ sender: Any) {
        self.stomachPainLabel.text = "Bol u trbuhu - " + String(Int(stomachPainSlider.value))
    }
}

extension HeadacheVC: HeadacheShouldBeDismissed {
    func setDismiss() {
        self.shouldBeDismissed = true
    }
}

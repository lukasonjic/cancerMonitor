//
//  Entry.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 22/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import Foundation

struct Entry{
    var entryTime: String?
    var temperature: Double?
    var nausea: String?
    var vomiting: String?
    var noOfVomitings: Int?
    var lossOfApetite: String?
    var changeOfTaste: String?
    var mucositis: String?
    var diarrhea: String?
    var constipation: String?
    var urinalProblems: String?
    var headache: Int?
    var chestPain: Int?
    var stomachPain: Int?
    var bleeding: String?
    var activity: String?
    var comment: String?
 
    
    func numberOfBadStats() -> Int {
        var count = 0
        if temperature! > 38.0 {
            count += 1
        }
        
        if lossOfApetite == "da" {
            count += 1
        }
        
        if noOfVomitings! >= 3 {
            count += 1
        }
        
        if nausea! == "stalna" {
            count += 1
        }
        
        if vomiting == "u više navrata" {
            count += 1
        }
        
        if diarrhea == "da" {
            count += 1
        }
        
        if constipation == "da" {
            count += 1
        }
        
        if urinalProblems == "da" {
            count += 1
        }
        
        if headache! >= 7 {
            count += 1
        }
        
        if chestPain! >= 7 {
            count += 1
        }
        
        if stomachPain! >= 7 {
            count += 1
        }
        
        if bleeding == "da" {
            count += 1
        }
        
        if activity!.lowercased() == "skroz neaktivan." {
            count += 1
        }
        
        return count
    }
    
    func shouldBeWarned() -> Bool {
        if (stomachPain == 10 || chestPain == 10 || headache == 10) || (temperature! > 39.0) || activity!.lowercased() == "skroz neaktivan." {
            return true
        }
        else {
            return false
        }
    }
}

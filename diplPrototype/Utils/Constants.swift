//
//  Constants.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 19/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let cancerTypes = ["leukemija", "tumor sredisnjeg zivcanog sustava", "maligni limfom", "neuroblastom", "Wilmsov tumor", "retinoblastom", "tumor zametnih stanica", "sarkom mekog tkiva", "tumor jetre", "maligni tumor kostiju", "tumor mozga"]
    static let nausea = ["nema", "jutarnja", "nakon jela", "stalna"]
    static let vomiting = ["ne", "jednom", "jednom, nakon jela", "u više navrata"]
    static let mucositis = ["ne", "blagi", "srednji", "teški"]
    static let activity = ["Skroz neaktivno.", "Manje aktivno nego inače.", "Uobičajeno aktivno.", "Aktivnije nego inače."]
    static let maleColor = UIColor.init(red: 204.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 0.8)
    static let femaleColor = UIColor.init(red: 255.0/255.0, green: 204.0/255.0, blue: 51.0/255.0, alpha: 0.8)
    static let credits = "Aplikacija je razvijena za predmet Diplomski rad 2017./2018. godine.\n\nMentorica: prof. dr. sc. Željka Car\n\nAsistentice: mag. oec. Ivana Rašan, mag. ing. Matea Žilak\n\nStudent: Luka Šonjić\n\nPosebne zahvale doc. dr. sc. Jasminki Stepan Giljević i dr. med. Filipu Jadrijeviću na ukazanoj pomoći i savjetima.\n\nAutori ikona su: Bainat, Freepik, Gregor Cresnar, Good Ware, Icon Pond, Smashicons"
}

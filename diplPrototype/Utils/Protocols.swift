//
//  Protocols.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 26/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import Foundation

protocol SetupEmailForSubmit {
    func setEmail(email: String)
}

protocol HeadacheShouldBeDismissed {
    func setDismiss()
}

protocol MucositisShouldBeDismissed {
    func setDismiss()
}

protocol TemperatureShouldBeDismissed {
    func setDismiss()
}

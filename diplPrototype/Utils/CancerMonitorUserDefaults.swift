//
//  CancerMonitorUserDefaults.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 13/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import Foundation
struct Keys {
    static let emailKey = "emailKey"
    static let firstNameKey = "firstNameKey"
    static let lastNameKey = "lastNameKey"
    static let dobKey = "dobKey"
    static let genderKey = "genderKey"
    static let cancerTypeKey = "cancerTypeKey"
    static let radiationKey = "radiationKey"
    static let operationKey = "operationKey"
    static let doctorEmailKey = "doctorEmailKey"
    static let myTokenKey = "myTokenKey"
    static let isDoctorKey = "isDoctorKey"
    static let alarmKey = "alarmKey"
    static let workplaceKey = "workplaceKey"
    static let openingHourKey = "openingHourKey"
    static let closingHourKey = "closingHourKey"
    static let phoneNumberKey = "phoneNumberKey"
    static let notificationKey = "notificationKey"
}

class CancerMonitorUserDefaults {
    
    static let sharedInstance = CancerMonitorUserDefaults()
    
    func setToken(token: String, isDoctor: Bool){
        UserDefaults.standard.set(token, forKey: Keys.myTokenKey)
        UserDefaults.standard.set(isDoctor, forKey: Keys.isDoctorKey)
    }
    
    
    func getMyToken() -> String? {
        return UserDefaults.standard.string(forKey: Keys.myTokenKey)
    }
    
    func isDoctor() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.isDoctorKey)
    }
   
    func getPatient() -> Patient {
        var patient = Patient()
        patient.firstName = UserDefaults.standard.string(forKey: Keys.firstNameKey)
        patient.lastName = UserDefaults.standard.string(forKey: Keys.lastNameKey)
        patient.dateOfBirth = UserDefaults.standard.string(forKey: Keys.dobKey)
        patient.gender = UserDefaults.standard.string(forKey: Keys.genderKey)
        patient.email = UserDefaults.standard.string(forKey: Keys.emailKey)
        patient.doctorsEmail = UserDefaults.standard.string(forKey: Keys.doctorEmailKey)
        patient.cancerType = UserDefaults.standard.string(forKey: Keys.cancerTypeKey)
        patient.radiationTherapy = UserDefaults.standard.string(forKey: Keys.radiationKey)
        patient.operation = UserDefaults.standard.string(forKey: Keys.operationKey)
        
        return patient
    }
    
    func getDoctor() -> Doctor {
        var doctor = Doctor()
        doctor.firstName = UserDefaults.standard.string(forKey: Keys.firstNameKey)
        doctor.lastName = UserDefaults.standard.string(forKey: Keys.lastNameKey)
        doctor.dateOfBirth = UserDefaults.standard.string(forKey: Keys.dobKey)
        doctor.gender = UserDefaults.standard.string(forKey: Keys.genderKey)
        doctor.email = UserDefaults.standard.string(forKey: Keys.emailKey)
        doctor.workplace = UserDefaults.standard.string(forKey: Keys.workplaceKey)
        doctor.phoneNumber = UserDefaults.standard.string(forKey: Keys.phoneNumberKey)
        doctor.openingHour = UserDefaults.standard.string(forKey: Keys.openingHourKey)
        doctor.closingHour = UserDefaults.standard.string(forKey: Keys.closingHourKey)
        
        return doctor
        
    }
    
    func setPatient(patient: Patient){
        UserDefaults.standard.set(patient.firstName, forKey: Keys.firstNameKey)
        UserDefaults.standard.set(patient.lastName, forKey: Keys.lastNameKey)
        UserDefaults.standard.set(patient.email, forKey: Keys.emailKey)
        UserDefaults.standard.set(patient.dateOfBirth, forKey: Keys.dobKey)
        UserDefaults.standard.set(patient.gender, forKey: Keys.genderKey)
        UserDefaults.standard.set(patient.cancerType, forKey: Keys.cancerTypeKey)
        UserDefaults.standard.set(patient.radiationTherapy, forKey: Keys.radiationKey)
        UserDefaults.standard.set(patient.operation, forKey: Keys.operationKey)
        UserDefaults.standard.set(patient.doctorsEmail, forKey: Keys.doctorEmailKey)
        Notifications.shared.requestAuthorization()
        self.setHour(hour: 20)
    }
    
    func setDoctor(doctor: Doctor){
        UserDefaults.standard.set(doctor.email, forKey: Keys.emailKey)
        UserDefaults.standard.set(doctor.firstName, forKey: Keys.firstNameKey)
        UserDefaults.standard.set(doctor.lastName, forKey: Keys.lastNameKey)
        UserDefaults.standard.set(doctor.workplace, forKey: Keys.workplaceKey)
        UserDefaults.standard.set(doctor.gender, forKey: Keys.genderKey)
        UserDefaults.standard.set(doctor.dateOfBirth, forKey: Keys.dobKey)
        UserDefaults.standard.set(doctor.openingHour, forKey: Keys.openingHourKey)
        UserDefaults.standard.set(doctor.closingHour, forKey: Keys.closingHourKey)
        UserDefaults.standard.set(doctor.phoneNumber, forKey: Keys.phoneNumberKey)
        UserDefaults.standard.set(20, forKey: Keys.notificationKey)
        UserDefaults.standard.set(true, forKey: Keys.isDoctorKey)
    }
    
    func setHour(hour: Int){
        UserDefaults.standard.set(hour, forKey: Keys.notificationKey)
    }
    
    func getHour() -> Int{
        return UserDefaults.standard.integer(forKey: Keys.notificationKey)
    }
    
    func setRadiation(_ str: String) {
        UserDefaults.standard.set(str, forKey: Keys.radiationKey)
    }
    
    func setOperation(_ str: String) {
        UserDefaults.standard.set(str, forKey: Keys.operationKey)
    }
    
    func getMyEmail() -> String {
        return UserDefaults.standard.string(forKey: Keys.emailKey)!
    }
    
    func setAlarm(){
        //UserDefaults.standard.set(<#T##value: Any?##Any?#>, forKey: Keys.alarmKey)
    }
    
    func cleanLogout(){
        UserDefaults.standard.removeObject(forKey: Keys.firstNameKey)
        UserDefaults.standard.removeObject(forKey: Keys.lastNameKey)
        UserDefaults.standard.removeObject(forKey: Keys.emailKey)
        UserDefaults.standard.removeObject(forKey: Keys.dobKey)
        UserDefaults.standard.removeObject(forKey: Keys.genderKey)
        UserDefaults.standard.removeObject(forKey: Keys.cancerTypeKey)
        UserDefaults.standard.removeObject(forKey: Keys.radiationKey)
        UserDefaults.standard.removeObject(forKey: Keys.operationKey)
        UserDefaults.standard.removeObject(forKey: Keys.doctorEmailKey)
        UserDefaults.standard.removeObject(forKey: Keys.workplaceKey)
        UserDefaults.standard.removeObject(forKey: Keys.openingHourKey)
        UserDefaults.standard.removeObject(forKey: Keys.closingHourKey)
        UserDefaults.standard.removeObject(forKey: Keys.phoneNumberKey)
        UserDefaults.standard.removeObject(forKey: Keys.isDoctorKey)
        UserDefaults.standard.removeObject(forKey: Keys.myTokenKey)
        UserDefaults.standard.removeObject(forKey: Keys.alarmKey)
        UserDefaults.standard.removeObject(forKey: Keys.notificationKey)
        Notifications.shared.removeAll()
    }
}

extension CancerMonitorUserDefaults{
   
    
}

//
//  APIService.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 12/05/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let BASE_URL = "http://172.20.10.3:3000/"

class APIService {
    
    
    static let shared = APIService()
    
    static let sharedSessionManager: SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "http://172.20.10.3:3000/": .disableEvaluation,
        ]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        return sessionManager
    }()
    
    func login(_ username: String, password: String, completion: @escaping ((APIResponse<JSON>) -> Void)){

        let params = ["email": username, "password": password]

        let headersUpdate = ["authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoibG9naW5AbG9naW4ubG9naW4iLCJpYXQiOjE1MjYwNTYyMTl9.-2XzJbnGTNhmSO5E-RnDkskl8Bj4TQmCMbylrT0gjAI"]
        
        self.request(BASE_URL+"login", headersUpdate: headersUpdate, parameters: params, method: .post, hasToken: false, completion: {
            result, error in
            if error != nil{
                print("Error - user could not be logged in")
                if let err = error {
                    switch err {
                    case .wrongPassword( _, let title, let message):
                        completion(.error(title, message))
                    case .serverError( _, let title, _):
                        completion(.error(title, "Server unavailable at the moment."))
                    default:
                        completion(.error("", ""))
                    }
                }
            } else {
                if let json = result {
                    completion(.success(json))
                    if let tok = json.dictionaryValue["token"]?.string{
                        print(tok)
                    }
                    print("User \(username) successfully logged on.")
                    }
                }
        })
    }
    
    func register(email: String, emailDoctor: String, password: String, firstName: String, lastName: String,
                  dob: Date, gender: Int, cancerType: Int, radiationTherapy: Int, operation: Int,
                  completion: @escaping ((APIResponse<JSON>) -> Void)) {
        
        let cancer: String = Constants.cancerTypes[cancerType]
        
        var gend = "m"
        if gender != 0 {
            gend = "f"
        }
        
        var oper = "da"
        if operation != 0 {
            oper = "ne"
        }
        
        var radio = "da"
        if radiationTherapy != 0 {
            radio = "ne"
        }
        
        let doB = dob.getRightFormat()
        let params = ["email": email, "firstName": firstName, "lastName": lastName, "dateOfBirth": doB, "gender": gend, "cancerType": cancer, "radiationTherapy": radio, "operation": oper, "emailDoctor": emailDoctor, "password": password]
        
        let headersUpdate = ["authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoibG9naW5AbG9naW4ubG9naW4iLCJpYXQiOjE1MjYwNTYyMTl9.-2XzJbnGTNhmSO5E-RnDkskl8Bj4TQmCMbylrT0gjAI"]
        
        self.request(BASE_URL + "register", headersUpdate: headersUpdate, parameters: params, method: .post, hasToken: false) { (result, error) in
            if error != nil {
                switch error{
                case .userExists(_, _, _)?:
                    completion(.error("Pogreška", "Već postoji korisnik s istom email adresom."))
                case .wrongPassword(_,_,_)?:
                    completion(.error("Pogreška", "Ne postoji liječnik s tom email adresom."))
                default:
                    completion(.error("Pogreška","Molimo Vas provjerite podatke."))
                }
            } else if let json = result {
                completion(.success(json))
                if let tok = json.dictionaryValue["token"]?.string{
                    print(tok)
                    var pat = Patient()
                    pat.firstName = firstName
                    pat.lastName = lastName
                    pat.email = email
                    pat.doctorsEmail = emailDoctor
                    pat.dateOfBirth = doB
                    pat.radiationTherapy = radio
                    pat.operation = oper
                    pat.gender = gend
                    pat.cancerType = cancer
                    CancerMonitorUserDefaults.sharedInstance.setPatient(patient: pat)
                    CancerMonitorUserDefaults.sharedInstance.setToken(token: tok, isDoctor: false)
                }
            }
        }
    }
    
    func getMyDoctor(email: String, completion: @escaping ((APIResponse<JSON>) -> Void)){
        
        self.request(BASE_URL + "getDoctor", headersUpdate: ["email": email], parameters: nil, method: .get, hasToken: true) {
            (json, error) in
            if error != nil {
                completion(.error("",""))
            }
            if let result = json {
                completion(.success(result))
            }
        }
    }
    
    func updateEntry(entry: Entry, completion: @escaping ((APIResponse<JSON>) -> Void)){
        
        let params: [String: String] = ["email": CancerMonitorUserDefaults.sharedInstance.getMyEmail(), "entryTime": entry.entryTime!, "temperature": String(entry.temperature!), "nausea": entry.nausea!, "vomiting": entry.vomiting!, "noOfVomitings": String(entry.noOfVomitings!), "lossOfApetite": entry.lossOfApetite!, "changeOfTaste": entry.changeOfTaste!, "mucositis": entry.mucositis!, "diarrhea": entry.diarrhea!, "constipation": entry.constipation!, "urinalProblems": entry.urinalProblems!, "headache": String(entry.headache!), "chestPain": String(entry.chestPain!), "stomachPain": String(entry.stomachPain!), "bleeding": entry.bleeding!, "activity": entry.activity!, "comment": entry.comment!]
        
        self.request(BASE_URL + "updateEntry", headersUpdate: nil, parameters: params, method: .put, hasToken: true) {
            (result, error) in
            if error != nil {
                completion(.error("",""))
            } else {
                if let json = result {
                    completion(.success(json))
                }
            }
        }
        
    }
    
    func insertEntry(entry: Entry, completion: @escaping ((APIResponse<JSON>) -> Void)){
        let params: [String: String] = ["email": CancerMonitorUserDefaults.sharedInstance.getMyEmail(), "entryTime": entry.entryTime!, "temperature": String(entry.temperature!), "nausea": entry.nausea!, "vomiting": entry.vomiting!, "noOfVomitings": String(entry.noOfVomitings!), "lossOfApetite": entry.lossOfApetite!, "changeOfTaste": entry.changeOfTaste!, "mucositis": entry.mucositis!, "diarrhea": entry.diarrhea!, "constipation": entry.constipation!, "urinalProblems": entry.urinalProblems!, "headache": String(entry.headache!), "chestPain": String(entry.chestPain!), "stomachPain": String(entry.stomachPain!), "bleeding": entry.bleeding!, "activity": entry.activity!, "comment": entry.comment!]
        
        self.request(BASE_URL + "insertEntry", headersUpdate: nil, parameters: params, method: .post, hasToken: true) {
            (result, error) in
            if error != nil {
                completion(.error("",""))
            } else {
                if let json = result {
                    completion(.success(json))
                }
            }
        }
    }
    
    func updateMe(completion: @escaping ((APIResponse<JSON>) -> Void)) {
        let patient: Patient = CancerMonitorUserDefaults.sharedInstance.getPatient()
        let params: [String: String] = ["email": patient.email!, "firstName": patient.firstName!, "lastName": patient.lastName!, "dateOfBirth": patient.dateOfBirth!, "gender": patient.gender!, "cancerType": patient.cancerType!, "radiationTherapy": patient.radiationTherapy!, "operation": patient.operation! ]
        
        self.request(BASE_URL + "updatePatient", headersUpdate: nil, parameters: params, method: .put, hasToken: true) { (json, error) in
            if error != nil {
                completion(.error("",""))
            } else {
                if let result = json {
                    completion(.success(result))
                }
            }
        }
    }
    
    func getEntrys(email: String, completion: @escaping ((APIResponse<JSON>) -> Void)) {
        let headers = ["email": email]
        self.request(BASE_URL + "getEntrys", headersUpdate: headers, parameters: nil, method: .get, hasToken: true) {
            (json, error) in
            if error != nil {
                completion(.error("",""))
            } else {
                if let result = json {
                    completion(.success(result))
                }
            }
        }
    }
    
    func getPatient(email: String, completion: @escaping ((APIResponse<JSON>) -> Void)) {
        let headers = ["email": email]
        
        self.request(BASE_URL + "getPatient", headersUpdate: headers, parameters: nil, method: .get, hasToken: true) { (result, error) in
            if error != nil {
                completion(.error("",""))
            } else {
                if let json = result {
                    completion(.success(json))
                }
            }
        }
    }
    
    func getMyPatients(email: String, completion: @escaping ((APIResponse<JSON>) -> Void)) {
        let headers = ["email": email]
        
        self.request(BASE_URL + "getMyPatients", headersUpdate: headers, parameters: nil, method: .get, hasToken: true) { (result, error) in
            if error != nil {
                completion(.error("",""))
            } else {
                if let json = result {
                    completion(.success(json))
                }
            }
        }
    }
    
    func getDoctorByMyEmail(email: String, completion: @escaping ((APIResponse<JSON>) -> Void)) {
        let headers = ["email": email]
        
        self.request(BASE_URL + "getMyDoctor", headersUpdate: headers, parameters: nil, method: .get, hasToken: true) {
            (result, error) in
            if error != nil {
                completion(.error("",""))
            } else {
                if let json = result {
                    completion(.success(json))
                }
            }
        }
    }
    
}

extension APIService{
    
    fileprivate func request(_ url: URLConvertible, headersUpdate:Parameters?, parameters: Parameters?, method: HTTPMethod, hasToken: Bool, completion: @escaping (_ result: JSON?, _ error:NetworkAPIError?) -> Void){
        var headers = [ "Content-type": "application/json"]
        
        if headersUpdate != nil {
            for keys in headersUpdate!.keys {
                headers[keys] = headersUpdate![keys] as? String
            }
        }
        
        if hasToken {
            if let token = CancerMonitorUserDefaults.sharedInstance.getMyToken() {
                headers["Authorization"] = "Bearer \(token)"
            }
        }
        
        APIService.sharedSessionManager.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {
            response in
            if (200 ... 299).contains(response.response!.statusCode) {
                let json = JSON(response.data as Any)
                completion(json, nil)
            } else {
                if (response.response?.statusCode == 403) {
                    completion(nil, .wrongPassword(code: 403, title: "Neovlašten pristup", message: "Molimo provjerite email i lozinku."))
                } else if (response.response?.statusCode)! >= 500 {
                    completion(nil, .serverError(code: (response.response?.statusCode)!, title: "Server error", message: ""))
                } else if response.response?.statusCode == 401 {
                    completion(nil, .userExists(code: 401, title: "Neovlašten pristup", message: ""))
                } else if response.response?.statusCode == 402 {
                    completion(nil, .wrongPassword(code: (response.response?.statusCode)!, title: "Neovlašten pristup.", message: "Ne postoji liječnik s tom email adresom."))
                } else {
                    completion(nil, .unknownError)
                }
            }
            
        })
        
    }
}

enum NetworkAPIError: Error{
    case loggedOut(code:Int, title:String, message:String)
    case serverError(code:Int, title:String ,message:String)
    case wrongPassword(code:Int, title: String, message: String)
    case userExists(code: Int, title: String, message: String)
    case unknownError
}

enum APIResponse<T> {
    case error(String, String)
    case success(T)
}

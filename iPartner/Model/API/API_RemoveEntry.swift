//
//  API_RemoveEntry.swift
//  iPartner
//
//  Created by Konstantin Mishukov on 02/02/2019.
//  Copyright © 2019 Konstantin Mishukov. All rights reserved.
//


// NOT YET IMPLEMENTED

//import Foundation
//
//extension API {
//    static func remove_entry(id: String, completion: @escaping (_ result: Result, _ didDelete: Bool?) -> ()) -> () {
//        let parameters = [
//            "a":"remove_entry",
//            "session":"\(API.session)",
//            "id":"\(id)"
//        ]
//        networkRequest(parameters: parameters) { (recieved) in
//            guard let result = recieved.result else { print("FatalError: recieved.result = nil"); return }
//            switch result {
//            case .Success:
//                guard let didDelete = recieved.json?["data"]["result"].boolValue else { print("FatalError: recieved.json?[\"data\"][\"id\"] returned nil"); return }
//                completion(.Success,didDelete)
//            case .ErrorAPI:
//                guard let error = recieved.json?["error"].stringValue else { print("FatalError: recieved.json?[\"error\"] = nil"); return }
//                print("ErrorAPI: \(String(error))")
//                completion(.ErrorAPI, nil)
//            case .ErrorHTTP:
//                completion(.ErrorHTTP,nil)
//            case .ErrorUnkwn:
//                completion(.ErrorUnkwn, nil)
//            }
//        }
//    }
//}

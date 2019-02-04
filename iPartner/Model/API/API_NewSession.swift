//
//  API_NewSession.swift
//  iPartner
//
//  Created by Konstantin Mishukov on 30/01/2019.
//  Copyright © 2019 Konstantin Mishukov. All rights reserved.
//

import Foundation

extension API {
    static func newSession(completion: @escaping (_ result: Result, _ id: String) -> () = { (result, data) in } ) -> ()  {
        let parameters = [
            "a":"new_session"
        ]
        networkRequest(parameters: parameters) { (recieved) in
            guard let result = recieved.result else { print("FatalError: recieved.result = nil"); return }
            
            switch result {
            case .Success:
                guard let id = recieved.json?["data"]["session"].stringValue else { print("FatalError: recieved.json?[\"data\"][\"session\"] returned nil"); return }
                print("New session: SUCCESS, Session ID: \(id)")
                UserDefaults.standard.saveSessionID(value: id)
                completion(.Success, id)
            case .ErrorAPI:
                completion(.ErrorAPI, recieved.json?["error"].stringValue ?? "???")
            case .ErrorHTTP:
                completion(.ErrorHTTP, recieved.error?.localizedDescription ?? "???")
            case .ErrorUnkwn:
                completion(.ErrorUnkwn, "Unknown Error")
            }
        }
    }
}

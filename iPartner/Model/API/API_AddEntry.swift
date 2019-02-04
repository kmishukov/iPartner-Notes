//
//  API_AddEntry.swift
//  iPartner
//
//  Created by Konstantin Mishukov on 30/01/2019.
//  Copyright © 2019 Konstantin Mishukov. All rights reserved.
//

import Foundation

extension API {
    static func add_entry(body: String, completion: @escaping (_ result: Result, _ id: String?, _ errMsg: String?) -> ()) -> () {
        let parameters = [
            "a":"add_entry",
            "session":"\(API.session)",
            "body":"\(body)"
        ]
        networkRequest(parameters: parameters) { (recieved) in
            guard let result = recieved.result else { print("FatalError: recieved.result = nil"); return }
            switch result {
            case .Success:
                guard let id = recieved.json?["data"]["id"].stringValue else { print("FatalError: recieved.json?[\"data\"][\"id\"] returned nil"); return }
                completion(.Success, id, nil)
            case .ErrorAPI:
                completion(.ErrorAPI, nil, recieved.json?["error"].stringValue ?? "???")
            case .ErrorHTTP:
                completion(.ErrorHTTP,nil, recieved.error?.localizedDescription ?? "???")
            case .ErrorUnkwn:
                completion(.ErrorUnkwn, nil, "Unknown Error")
            }
        }
    }
}

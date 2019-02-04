//
//  API_EditEntry.swift
//  iPartner
//
//  Created by Konstantin Mishukov on 02/02/2019.
//  Copyright © 2019 Konstantin Mishukov. All rights reserved.
//

import Foundation

extension API {
    static func edit_entry(id: String, body: String, completion: @escaping (_ result: Result, _ didEdit: Bool? , _ errorMessage: String?) -> ()) -> () {
        let parameters = [
            "a":"edit_entry",
            "session":"\(API.session)",
            "id":"\(id)",
            "body":"\(body)"
        ]
        networkRequest(parameters: parameters) { (recieved) in
            guard let result = recieved.result else { print("FatalError: recieved.result = nil"); return }
            switch result {
            case .Success:
                guard let didEdit = recieved.json?["data"]["result"].boolValue else { print("FatalError: recieved.json?[\"data\"][\"id\"] returned nil"); return }
                completion(.Success,didEdit, nil)
            case .ErrorAPI:
                completion(.ErrorAPI, nil, recieved.json?["error"].stringValue ?? "???" )
            case .ErrorHTTP:
                completion(.ErrorHTTP,nil , recieved.error?.localizedDescription ?? "???" )
            case .ErrorUnkwn:
                completion(.ErrorUnkwn, nil, "Unknown Error")
            }
        }
    }
}

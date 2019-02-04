//
//  API_GetEntries.swift
//  iPartner
//
//  Created by Konstantin Mishukov on 30/01/2019.
//  Copyright © 2019 Konstantin Mishukov. All rights reserved.
//

import Foundation
import SwiftyJSON

extension API {
    static func get_entries(completion: @escaping (_ result: Result, _ notes: [Note]?, _ errorMessage: String?) -> ()) -> () {
        let parameters = [
            "a":"get_entries",
            "session":"\(API.session)"
        ]
        networkRequest(parameters: parameters) { (recieved) in
            guard let result = recieved.result else { print("FatalError: recieved.result = nil"); return }
            switch result {
                case .Success:
                    var notes: [Note]?
                    guard let json = recieved.json?["data"].arrayValue else { print("FatalError: recieved.json[\"data\"] = nil"); return }
                    for item in json {
                        notes = Note.initialize(json: item.arrayValue)
                    }
                    completion(result, notes, nil)
                case .ErrorAPI:
                    completion(.ErrorAPI, nil, recieved.json?["error"].stringValue ?? "???")    
                case .ErrorHTTP:
                    completion(.ErrorHTTP, nil, recieved.error?.localizedDescription ?? "???")
                case .ErrorUnkwn:
                    completion(.ErrorUnkwn,nil,"Unknown Error")
            }

        }
    }
}

//
//  UserDefaults.swift
//  iPartner
//
//  Created by Konstantin Mishukov on 01/02/2019.
//  Copyright © 2019 Konstantin Mishukov. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func saveSessionID(value: String){
        API.session = value
        set(value, forKey: UserDefaultKeys.sessionId.rawValue)
    }
    
    func loadSessionID() -> String? {
        return string(forKey: UserDefaultKeys.sessionId.rawValue)
    }
    
    enum UserDefaultKeys: String {
        case sessionId
    }
    
}


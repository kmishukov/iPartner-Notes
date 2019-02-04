//
//  Note.swift
//  iPartner
//
//  Created by Konstantin Mishukov on 30/01/2019.
//  Copyright © 2019 Konstantin Mishukov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Note {
    public var id: String?
    public var msg: String?
    public var da: String?
    public var dm: String?
}

extension Note {
    
    init(json: JSON) {
        id = json["id"].stringValue
        msg = json["body"].stringValue
        da = json["da"].stringValue
        dm = json["dm"].stringValue
    }
    
    public static func initialize(json: [JSON]) -> [Note] {
        return json.map {Note(json: $0) }
    }
}

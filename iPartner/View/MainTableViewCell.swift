//
//  MainTableViewCell.swift
//  iPartner
//
//  Created by Konstantin Mishukov on 31/01/2019.
//  Copyright © 2019 Konstantin Mishukov. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var daLabel: UILabel!
    @IBOutlet weak var dmLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func configureCell(note: Note) {
        if let da = note.da {
            daLabel.alpha = 0.75
            daLabel.text = "Created: " + (Double(da)?.getDateStringFromUTC())!
            if let dm = note.dm  {
                if dm != da {
                    dmLabel.alpha = 0.75
                    dmLabel.text = "Modified: " + (Double(dm)?.getDateStringFromUTC())!
                } else {
                    dmLabel.text = ""
                }
            }
        }
        if let message = note.msg {
            messageLabel.textAlignment = .natural
            messageLabel.numberOfLines = 0
            if message.count > 200 {
                messageLabel.text = String(message[message.startIndex..<message.index(message.startIndex, offsetBy: 200)])
            } else {
                messageLabel.text = message
            }
        }
    }
    
}

extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, H:mm"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
}

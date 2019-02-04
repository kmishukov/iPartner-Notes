//
//  ErrorHandling.swift
//  iPartner
//
//  Created by Konstantin Mishukov on 31/01/2019.
//  Copyright © 2019 Konstantin Mishukov. All rights reserved.
//

import Foundation
import UIKit

protocol errorHandlerDelegate {
    func refreshButtonPressed(_ sender: UIBarButtonItem?)
    func save(_ sender: UIBarButtonItem?)
}

extension errorHandlerDelegate where Self: UIViewController {
    
     func showErrorMessage(result: Result, message: String?) {
        
        var title: String?
        var description: String?
        var actionsArray: [UIAlertAction] = []
        
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        actionsArray.append(okAction)
        
        switch result {
        case .Success:
            break
        case .ErrorAPI:
            title = "API Error"
            description = "\(message ?? "???")"
        case .ErrorHTTP:
            title = "Network Error"
            description = "\(message ?? "???")"
            let retry = UIAlertAction.init(title: "Retry", style: .default, handler: { (UIAlertAction) in
                if self is MainViewController {
                    self.refreshButtonPressed(self.navigationItem.leftBarButtonItem ?? nil)
                } else if self is MessageViewController {
                    self.save(self.navigationItem.rightBarButtonItem ?? nil)
                }
            })
            actionsArray.append(retry)
        case .ErrorUnkwn:
            title = "Unnkown Error"
            description = "Unknown Error"
        }
        
        let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
        for action in actionsArray {
            alert.addAction(action)
        }
        DispatchQueue.main.async {
              self.present(alert, animated: true, completion: nil)
        }
    }
    
    func refreshButtonPressed(_ sender: UIBarButtonItem?) {}
    func save(_ sender: UIBarButtonItem?) {}
}

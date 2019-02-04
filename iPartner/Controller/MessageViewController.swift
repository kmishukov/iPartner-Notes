//
//  MessageViewController.swift
//  iPartner
//
//  Created by Konstantin Mishukov on 31/01/2019.
//  Copyright © 2019 Konstantin Mishukov. All rights reserved.
//

import UIKit

public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

class MessageViewController: UIViewController, UITextViewDelegate, errorHandlerDelegate {
    
    var isAddingMode: Bool { get { return presentingViewController is UINavigationController }}
    let indicator = UIActivityIndicatorView()
    var noteId: String?
    var textView = UITextView()
    var delegate: errorHandlerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
    }
    
    // Launch configurations
    
    func configureTextView(){
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        view.addSubview(textView)

        textView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        if isAddingMode == false {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isAddingMode { textView.becomeFirstResponder() }
    }
    
    // UIBarButtonItem Methods
    
    @IBAction func cancel(_ sender: UIBarButtonItem){
        view.endEditing(true)
        if isAddingMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem?) {
        indicator.style = .gray
        indicator.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: indicator)
        view.endEditing(true)
        
        if isAddingMode {
            API.add_entry(body: self.textView.text) { (result, id, errorMsg) in
                if result == .Success {
                    print("Message successfully added. Message id: \(id ?? "Error")");
                    DispatchQueue.main.async {
                        self.navigationItem.rightBarButtonItem = sender
                        self.dismiss(animated: true, completion: nil)
                        self.delegate?.refreshButtonPressed(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigationItem.rightBarButtonItem = sender
                        self.showErrorMessage(result: result, message: errorMsg ?? "???")
                    }
                }
            }
        } else {
            guard let id = self.noteId else { print("FatalError: noteId returned nil"); return }
            API.edit_entry(id: id, body: self.textView.text) { (result, bool, errorMsg) in
                if result == .Success && bool == true {
                    print("Message successfully edited & saved. Message id: \(id)");
                    if let owningNavigationController = self.navigationController {
                        DispatchQueue.main.async {
                            self.navigationItem.rightBarButtonItem = sender
                            owningNavigationController.popViewController(animated: true)
                            self.delegate?.refreshButtonPressed(nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigationItem.rightBarButtonItem = sender
                        self.showErrorMessage(result: result, message: errorMsg ?? "???" )
                    }
                }
            }
        }
    }
    
    // UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        if isAddingMode == false {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}

//
//  MainViewController.swift
//  iPartner
//
//  Created by Konstantin Mishukov on 30/01/2019.
//  Copyright © 2019 Konstantin Mishukov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, errorHandlerDelegate {

    @IBOutlet weak var tableView: UITableView!
    let indicator = UIActivityIndicatorView()
    var notes: [Note]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alpha = 0
        self.navigationItem.title = "i-Partner Notes"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        launchConfigurations()
    }
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = notes?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        guard let array = notes else { print("Error: notes:[Note] returned nil"); return cell }
        cell.configureCell(note: array[indexPath.row])
        return cell
    }
    
    // Populate TableView (launch)
    func launchConfigurations() {
        if let sessionID = UserDefaults.standard.loadSessionID() {
            API.session = sessionID
            self.getNotesList(sender: self.navigationItem.leftBarButtonItem)
        } else {
            API.newSession { result,id  in
                if result == .Success {
                    self.getNotesList(sender: self.navigationItem.leftBarButtonItem)
                } else {
                    self.showErrorMessage(result: result, message: id)
                }
            }
        }
    }
    
    // Refresh TableView (если sender == nil, функция считается запущенной в background-e, значит в случае ошибок UIAlert не будет вызван)
    func getNotesList(sender: UIBarButtonItem?){
        if sender != nil {
            startActivityIndicator()
        }
        API.get_entries(completion: { (result, array, error) in
            if result == .Success {
                self.notes = array
                DispatchQueue.main.async {
                    if sender != nil {
                        self.navigationItem.leftBarButtonItem = sender
                        self.tableView.animateOutAndRefresh()
                    } else {
                        self.tableView.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    guard sender != nil else { return }
                    self.navigationItem.leftBarButtonItem = sender
                    if let err = error {
                        self.showErrorMessage(result: result, message: err)
                    }
                    self.tableView.alpha = 1
                }
            }
        })
    }
    
    // ActivityIndicator
    func startActivityIndicator(){
        DispatchQueue.main.async {
            self.indicator.style = .gray
            self.indicator.startAnimating()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.indicator)
        }
    }
    
    // UIBarButtonActions
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem?) {
        getNotesList(sender: sender)
    }
    
    //PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNote" {
            let nav = segue.destination as! UINavigationController
            let destionation = nav.topViewController as! MessageViewController
                destionation.navigationItem.title = "Add Note"
                destionation.delegate = self
        } else if segue.identifier == "editNote" {
            let destination = segue.destination as! MessageViewController
            destination.navigationItem.title = "Edit Note"
            guard let indexPath = tableView.indexPathForSelectedRow,
                let id = notes?[indexPath.row].id,
                let message = notes?[indexPath.row].msg else { print("fatalError: could not pass data to messageViewController"); return }
            destination.noteId = id
            destination.textView.text = message
            destination.delegate = self
        }
    }
}

// TableView FadeIn & FadeOut animations
extension UITableView {
    
    func reloadData(completion: @escaping ()->() ) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() }) {
            _ in completion()
        }
    }
    
    func animateOutAndRefresh() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3,delay: 0, animations: {
                self.alpha = 0
            }) { (_) in
                self.reloadData {
                    self.animateIn()
                }
            }
        }
    }
    
    func animateIn(){
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
}

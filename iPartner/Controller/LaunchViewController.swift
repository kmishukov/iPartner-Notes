//
//  LaunchViewController.swift
//  iPartner
//
//  Created by Konstantin Mishukov on 04/02/2019.
//  Copyright © 2019 Konstantin Mishukov. All rights reserved.
//

import UIKit

extension UIColor {
    static let backgroundRed = UIColor(red: 223/255.0, green: 57/255.0, blue: 40/255.0, alpha: 1)
}

class LaunchViewController: UIViewController {

    let imageView = UIImageView()
    var yImageViewConstraint = NSLayoutConstraint()
    let titleLabel = UILabel()
    var xTitleConstraint = NSLayoutConstraint()
    let madeByLabel = UILabel()
    var xMadeByConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        view.backgroundColor = .backgroundRed
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.image = UIImage(named: "logo.png")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        yImageViewConstraint = imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        yImageViewConstraint.isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.frame = CGRect(x: 0, y: 0, width: 200 , height: 30)
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.text = "iPartner - Notes"
        view.addSubview(titleLabel)
        xTitleConstraint = titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -400)
        xTitleConstraint.isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        madeByLabel.translatesAutoresizingMaskIntoConstraints = false
        madeByLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        madeByLabel.textColor = .white
        madeByLabel.font = UIFont.boldSystemFont(ofSize: 20)
        madeByLabel.text = "Made by Mishukov Konstantin"
        view.addSubview(madeByLabel)
        xMadeByConstraint = madeByLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 400)
        xMadeByConstraint.isActive = true
        madeByLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 60).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
       self.perform(#selector (self.animateInAndOut), with: nil, afterDelay: 0.5)
    }
    
    @objc func animateInAndOut(){
        yImageViewConstraint.constant = -160
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            self.xTitleConstraint.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                self.xMadeByConstraint.constant = 0
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (_) in
                    UIView.animate(withDuration: 1, delay: 1, animations: {
                        var transform = CGAffineTransform.identity
                        transform = transform.rotated(by: 540.0 * 3.14/180.0)
                        transform = transform.scaledBy(x: 0.01, y: 0.01)
                        self.imageView.transform = transform
                    }, completion: { (_) in
                        self.imageView.isHidden = true
                        UIView.animate(withDuration: 0.4, animations: {
                            self.view.backgroundColor = .white
                        }, completion: { (_) in
                            self.perform(#selector (self.segueToMain), with: nil, afterDelay: 0)
                        })
                    })
                    
                })
            })
        }
    }

    @objc func segueToMain(){
        performSegue(withIdentifier: "segueToMain", sender: nil)
    }
    
}

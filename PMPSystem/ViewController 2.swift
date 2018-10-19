//
//  ViewController.swift
//  PMPSystem
//
//  Created by Oliver Lin on 7/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let ref = Database.database().reference(fromURL: "https://pmpsystem-f537e.firebaseio.com/")
        ref.updateChildValues(["someValue": 123123])
        
        // user didn't loggin
        if Auth.auth().currentUser?.uid == nil{
            handleLogout()
        }
        
        
    }
    
    @objc func handleLogout(){
        
        do{
            try Auth.auth().signOut()
        } catch let error{
            print(error)
        }
        
        let loginController = LoginViewController()
        self.present(loginController, animated: true)
    }

}


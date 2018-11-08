//
//  ItemOneViewController.swift
//  PMPSystem
//
//  Created by Oliver Lin on 15/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase

class ItemOneViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // user didn't loggin
        if Auth.auth().currentUser?.uid == nil{
            self.present(LoginViewController(), animated: true)
        }
    }
}
    



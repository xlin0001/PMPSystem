//
//  ItemOneViewController.swift
//  PMPSystem
//
//  Created by Oliver Lin on 15/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase

class ItemOneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // user didn't loggin
        if Auth.auth().currentUser?.uid == nil{
            self.present(LoginViewController(), animated: true)
        }

    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


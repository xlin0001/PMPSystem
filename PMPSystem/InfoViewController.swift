//
//  InfoViewController.swift
//  PMPSystem
//
//  Created by Oliver Lin on 15/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase

class InfoViewController: UIViewController {
    
    @IBAction func handleLogout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        } catch let error{
            print(error)
        }
        
        let loginController = LoginViewController()
        self.present(loginController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

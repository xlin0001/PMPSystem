//
//  ViewController.swift
//  PMPSystem
//
//  Created by Oliver Lin on 7/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITabBarController {
    var logginViewController: LoginViewController?
    var myUser: MyUser?
    var refHandle: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refHandle = Database.database().reference(fromURL: "https://pmpsystem-f537e.firebaseio.com/")
        myUser = MyUser.onlyUser
        handleUser(myUser!)
    }
    
    func handleUser(_ user: MyUser){
        if Auth.auth().currentUser?.uid != nil{
            myUser?.uid = Auth.auth().currentUser?.uid

            let userRef = refHandle?.child("users").child((myUser?.uid)!)
            userRef?.observeSingleEvent(of: .value, with: { (snapshot) in
                // get user value.
                let value = snapshot.value as? NSDictionary
                self.myUser?.emailAddress = value?["emailAddress"] as? String ?? ""
                self.myUser?.name = value?["name"] as? String ?? ""
                let profileImageURL = value?["identityImageURL"] as? String ?? ""

                let url = URL(string: profileImageURL)
                
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        // if download hits an error, so lets return out
                        print(error)
                        return
                    }
                    // if there is no error happens...
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // in half a second...
                        self.myUser?.identityImage = UIImage(data: data!)
                        let infoController = InfoViewController()
                        //info
                    }
                }).resume()
            })
        }
    }
}



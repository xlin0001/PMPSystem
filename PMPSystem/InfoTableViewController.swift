//
//  InfoTableViewController.swift
//  PMPSystem
//
//  Created by Oliver Lin on 15/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase

class InfoTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileEmailLabel: UILabel!
    var myUser: MyUser?
    var emailAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        myUser = MyUser.onlyUser
        setupPicture(pictureView: profileImageView)
        profileEmailLabel.text = myUser?.emailAddress
        profileImageView.image = myUser?.identityImage
        
    }
    
    func setupPicture(pictureView: UIImageView) -> UIImageView{
        pictureView.layer.cornerRadius = CGFloat(5)
        pictureView.clipsToBounds = true
        return pictureView
    }
}

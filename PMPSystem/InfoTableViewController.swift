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
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor  = UIColor(red: 61, green: 91, blue: 151)
         self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tableView.tableFooterView = UIView()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor  = UIColor(red: 61, green: 91, blue: 151)
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 50
        }
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 200
            }
            return 50
        }
        return 0
    }
    
}

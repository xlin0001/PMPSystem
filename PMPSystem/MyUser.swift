//
//  MyUser.swift
//  PMPSystem
//
//  Created by Oliver Lin on 15/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import Foundation
import UIKit

class MyUser: NSObject {
    var uid: String?
    var emailAddress: String?
    var identityImage: UIImage?
    var name: String?
    
    // Singleton Pattern Constructor
    static let onlyUser = MyUser()
    
    init(uid: String, emailAddress: String, identityImage: UIImage, name: String) {
        self.uid = uid
        self.emailAddress = emailAddress
        self.identityImage  = identityImage
        self.name = name
    }
    
    override init(){}
}

//
//  ProjectorsTableViewCell.swift
//  PMPSystem
//
//  Created by Oliver Lin on 24/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProjectorsTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

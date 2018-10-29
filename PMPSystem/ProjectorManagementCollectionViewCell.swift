//
//  ProjectorManagementCollectionViewCell.swift
//  PMPSystem
//
//  Created by Oliver Lin on 24/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit

class ProjectorManagementCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var projectorImage: UIImageView!
    @IBOutlet weak var projectAlias: UILabel!
    @IBOutlet weak var projectBrand: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
}

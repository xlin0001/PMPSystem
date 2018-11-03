//
//  ReportTableViewCell.swift
//  PMPSystem
//
//  Created by 沈宇帆 on 2018/11/3.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    @IBOutlet weak var projectorImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

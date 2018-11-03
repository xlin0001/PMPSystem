//
//  Temp.swift
//  PMPSystem
//
//  Created by 沈宇帆 on 2018/11/2.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit

class Temp: NSObject {
    internal let id : Int
    internal let red : Double
    internal let blue : Double
    internal let green : Double
    internal let temp : Double
    init(id: Int, red: Double, blue: Double, green: Double, temp: Double) {
        self.id = id
        self.red = red
        self.blue = blue
        self.green = green
        self.temp = temp
    }
}

//
//  MyProjectors.swift
//  PMPSystem
//
//  Created by Oliver Lin on 25/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import Foundation
class MyProjector: NSObject {
    var alias: String?
    var brand: String?
    var date: Date?
    var lampType: String?
    var location: String?
    var maxLux: Double?
    var maxTemp: Double?
    var minTemp: Double?
    var power: Double?
    var type: String?
    
    init(alias: String, brand: String, date: Date, lampType: String, location: String, maxLux: Double, maxTemp: Double, minTemp: Double, power: Double, type: String) {
        self.alias = alias
        self.brand = brand
        self.date = date
        self.lampType = lampType
        self.location = location
        self.maxLux = maxLux
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.power = power
        self.type = type
    }
    
    override init(){}
}

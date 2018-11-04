//
//  VoiceData.swift
//  PMPSystem
//
//  Created by Oliver Lin on 4/11/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import Foundation
import UIKit

class VoiceData: NSObject{
    var dateAndTime: Int
    var voice: Int
    
    init(dateAndTime: Int, voice: Int) {
        self.dateAndTime = dateAndTime
        self.voice = voice
    }
}

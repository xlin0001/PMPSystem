//
//  Util.swift
//  PMPSystem
//
//  Created by Oliver Lin on 23/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Util: NSObject{
    //static method to resize image, take a image and a target size as primeters.
    class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func calcutateIlluminance(red: Double, green: Double, blue: Double) -> Double{
        let redValue = red * 64
        let greenValue = green * 64
        let blueValue = blue * 64
        
        var illuminance = (-0.32466) * redValue + (1.57837) * greenValue + (-0.73191) * blueValue
         illuminance = Double(round(1000*illuminance)/1000)
        return illuminance
    }
    
    class func calcuateColourTemperature(red: Double, green: Double, blue: Double) -> Double{
        let redValue = red * 64
        let greenValue = green * 64
        let blueValue = blue * 64
        
        let CIETristimulusX = (-0.14282) * redValue + (1.54924) * greenValue + (-0.95641) * blueValue
        let CIETristimulusY = Util.calcutateIlluminance(red: red, green: green, blue: blue)
        let CIETristimulusZ = (-0.68202) * redValue + (0.77073) * greenValue + (0.56332) * blueValue
        
        let chromaticityCoordinateX = CIETristimulusX / (CIETristimulusX + CIETristimulusY + CIETristimulusZ)
        let chromaticityCoordinateY = CIETristimulusY / (CIETristimulusX + CIETristimulusY + CIETristimulusZ)
        
        let n = (chromaticityCoordinateX - 0.3320) / (0.1858 - chromaticityCoordinateY)
        
        var correlatedColourTemperature = 449 * pow(n, 3) + 3525 * pow(n, 2) + 5520.33
        
        correlatedColourTemperature = Double(round(1000*correlatedColourTemperature)/1000)
        
        return correlatedColourTemperature
    }
    
    class func removeStringQuotationMark(string: String) -> String {
        var str = string
        str.remove(at: str.startIndex)
        str.remove(at: str.endIndex)
        return str
    }
    
    // this class function convers raspio Unix raw time formate to human readable time...
    class func convertUnixTimeToDate(timeIntervalSince1970: Int) -> String{
        let timeIntervalSince1970String = String(timeIntervalSince1970)
        
        let timeIntervalSince1970String10Digits = timeIntervalSince1970String.prefix(10)
        
        let timeIntervalSince1970Double = Double(timeIntervalSince1970String10Digits)
        
        let date = Date(timeIntervalSince1970: timeIntervalSince1970Double!)
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        
        let timeInterval = NSDate().timeIntervalSince1970
        let time = timeInterval.description
        
        return dateFormatter.string(from: date)
    }
    
    class func compareTemperatureDifference(mapTemp: Double, currentTemp: Double) -> Double {
        return abs(mapTemp - currentTemp)
    }
    
    class func compareColourTemperatureDifference(originalColourTemp: Double, currentColourTemp: Double) -> Double {
        return abs(originalColourTemp - currentColourTemp)
    }
    
    class func campareBrightnessDifference(designedBrightness: Double, currentBrightness: Double) -> Double {
        return abs(designedBrightness - currentBrightness)
    }
}

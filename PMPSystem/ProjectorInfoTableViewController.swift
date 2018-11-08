//
//  ProjectorInfoTableViewController.swift
//  PMPSystem
//
//  Created by 沈宇帆 on 2018/11/2.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ProjectorInfoTableViewController: UITableViewController {

    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var projectorName: UILabel!
    @IBOutlet weak var crtTemp: UILabel!
    @IBOutlet weak var crtCtemp: UILabel!
    @IBOutlet weak var crtLux: UILabel!
    var imgUrl:String?
    var img:UIImage?
    var name:String?
    var sensorNo: String?
    var brand:String?
    var proType:String?
    var light:String?
    var maxTemp:Double?
    var minTemp:Double?
    var proLux:Double?
    var temps:[Temp] = []
    
    var lastTested: Int?
    var lastTemp: Double?
    var lastBrightness: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.tintColor = .white
        self.projectorName.text = name
        getImg()
        getTempData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    func getImg(){
        let url = URL(string: imgUrl!)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                // if download hits an error, so lets return out
                print(error)
                return
            }
            // if there is no error happens...
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // in half a second...
                self.projectImageView.image = UIImage(data: data!)
            }
        }).resume()
    }
    
    func getTempData(){
        let refHandle = Database.database().reference(fromURL: "https://pmpsystem-f537e.firebaseio.com/")
        let currentUserRef = refHandle.child("sensors").child(sensorNo!).child("temp")
        currentUserRef.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                self.temps.removeAll()
                for firebaseSensorData in snapshot.children.allObjects as! [DataSnapshot]{
                    let raspio = firebaseSensorData.value as! [String: AnyObject]
                    let id = raspio["date"] as! Int
                    let red = raspio["red"] as! Double
                    let blue = raspio["blue"] as! Double
                    let green = raspio["green"] as! Double
                    let temp = raspio["temp"] as! Double
                    self.lastTested = id
                    //self.lastBrightness = raspio["maxLux"] as! Double
                    
                    // have to make sure that this object is not nil
                    self.temps.append(Temp(id: id, red: red, blue: blue, green: green, temp: temp))
                }
                
                    
                }
            self.crtTemp.text = "Current Temperature: \((self.temps.last?.temp)!)"
            self.lastTemp = (self.temps.last?.temp)!
            self.lastBrightness = Util.calcutateIlluminance(red: (self.temps.last?.red)!, green: (self.temps.last?.green)!, blue: (self.temps.last?.blue)!)
            
            
            
            self.crtCtemp.text = "Current Color Temperature: \(Util.calcuateColourTemperature(red: (self.temps.last?.red)!, green: (self.temps.last?.green)!, blue: (self.temps.last?.blue)!))"
            self.crtLux.text = "Current Lux: \(Util.calcutateIlluminance(red: (self.temps.last?.red)!, green: (self.temps.last?.green)!, blue: (self.temps.last?.blue)!))"
            
        })
        
    }
    //TO DO
    override func tableView(_ tableView: UITableView,accessoryButtonTappedForRowWith indexPath: IndexPath){
        if indexPath.section == 1 {
            let mianStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = mianStoryboard.instantiateViewController(withIdentifier: "DetailedTableViewController") as! DetailedTableViewController
            destination.brand = self.brand
            destination.light = self.light
            destination.maxTemp = self.maxTemp
            destination.minTemp = self.minTemp
            destination.name = self.name
            destination.proLux = self.proLux
            destination.proType = self.proType
            self.navigationController?.pushViewController(destination, animated: true)
        }
        // projector management section tapped
        if indexPath.section == 2 {
            print("projector management section tapped")
            // temperuature
            if indexPath.row == 0 {
//                print(maxTemp)
//                print(lastTemp)
//                print(Util.convertUnixTimeToDate(timeIntervalSince1970: lastTested!))
                let tempDifference = Util.compareTemperatureDifference(mapTemp: maxTemp!, currentTemp: lastTemp!)
                self.handleAlert(title: "Observe Message", message: "Last observed temperature at \(Util.convertUnixTimeToDate(timeIntervalSince1970: lastTested!)). Highest tolerance temperature: \(maxTemp!). Temperature difference: \(tempDifference)", actionTitle: "Sure", preferredStyle: .alert, preferredActionStyle: .default)
            }
            // colour temperature
            if indexPath.row == 1 {
                self.handleAlert(title: "Observe Message", message: "Last observed colour temperature at \(Util.convertUnixTimeToDate(timeIntervalSince1970: lastTested!))", actionTitle: "Sure", preferredStyle: .alert, preferredActionStyle: .default)
            }
            // brightness
            if indexPath.row == 2 {
                print(proLux)
                let brightnessDifference = Util.campareBrightnessDifference(designedBrightness: proLux!, currentBrightness: lastBrightness!)
                self.handleAlert(title: "Observe Message", message: "Last observed brightness at \(Util.convertUnixTimeToDate(timeIntervalSince1970: lastTested!)). Highest brightness: \(proLux!) Lux. Brightness difference: \(brightnessDifference) Lux", actionTitle: "Sure", preferredStyle: .alert, preferredActionStyle: .default)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 200
        }
        if indexPath.section == 1 {
            return 55
        }
        return 55
    }
    
    func handleAlert(title: String, message: String, actionTitle: String, preferredStyle: UIAlertController.Style, preferredActionStyle: UIAlertAction.Style){
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: actionTitle, style: preferredActionStyle, handler: nil))
        self.present(alert, animated: true)
    }
    

    

}

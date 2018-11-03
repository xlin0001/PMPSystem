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
                    // have to make sure that this object is not nil
                    self.temps.append(Temp(id: id, red: red, blue: blue, green: green, temp: temp))
                }
                
                    
                }
            self.crtTemp.text = "Current Temperature: \((self.temps.last?.temp)!)"
            self.crtCtemp.text = "Current Color Temperature: \(Util.calcuateColourTemperature(red: (self.temps.last?.red)!, green: (self.temps.last?.green)!, blue: (self.temps.last?.blue)!))"
            self.crtLux.text = "Current Lux: \(Util.calcutateIlluminance(red: (self.temps.last?.red)!, green: (self.temps.last?.green)!, blue: (self.temps.last?.blue)!))"
            
        })
        
    }
    
    override func tableView(_ tableView: UITableView,accessoryButtonTappedForRowWith indexPath: IndexPath){
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 200
        }
        if indexPath.section == 1 {
            return 55
        }
        return 55
    }
    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

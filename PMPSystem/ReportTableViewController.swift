//
//  ReportTableViewController.swift
//  PMPSystem
//
//  Created by 沈宇帆 on 2018/11/3.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class ReportTableViewController: UITableViewController {
    var projectorsList: [MyProjector] = []
    var imageUrlList:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.tintColor = .white
        handleProjectors()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func handleProjectors(){
        guard var userUID = Auth.auth().currentUser?.uid else {
            return
        }
        //retrieve the data from firebase
        let refHandle = Database.database().reference(fromURL: "https://pmpsystem-f537e.firebaseio.com/")
        userUID = (Auth.auth().currentUser?.uid)!
        let currentUserRef = refHandle.child("users").child(userUID).child("projectors")
        currentUserRef.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                self.projectorsList.removeAll()
                self.imageUrlList.removeAll()
                for firebaseSensorData in snapshot.children.allObjects as! [DataSnapshot]{
                    let projectors = firebaseSensorData.value as! [String: AnyObject]
                    let alias = projectors["alias"] as! String
                    let brand = projectors["brand"] as! String
                    let date = projectors["date"] as! String
                    let lampType = projectors["lampType"] as! String
                    let location = projectors["location"] as! String
                    let maxLux = projectors["maxLux"] as! String
                    let doubleMaxLux = Double(maxLux)
                    let maxTemp = projectors["maxTemp"] as! String
                    let doubleMaxTemp = Double(maxTemp)
                    let minTemp = projectors["minTemp"] as! String
                    let doubleMinTemp = Double(minTemp)
                    let type = projectors["type"] as! String
                    let profileImageURL = projectors["projectorProfileImageURL"] as? String ?? ""
                    self.imageUrlList.append(profileImageURL)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MM YYYY"
                    let formatedDate = dateFormatter.date(from: date)
                    self.projectorsList.append(MyProjector(alias: alias, brand: brand, date: formatedDate!, lampType: lampType, location: location, maxLux: doubleMaxLux!, maxTemp: doubleMaxTemp!, minTemp: doubleMinTemp!, power: 0, type: type))
                    
                }
                self.tableView.reloadData()
            }
        })
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projectorsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportTableViewCell
        // Configure the cell...
        cell.nameLabel.text = projectorsList[indexPath.row].alias
        let urlString = self.imageUrlList[indexPath.row]
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                // if download hits an error, so lets return out
                print(error)
                return
            }
            // if there is no error happens...
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // in half a second...
                cell.projectorImg.image = UIImage(data: data!)
            }
        }).resume()
        return cell
    }
 

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

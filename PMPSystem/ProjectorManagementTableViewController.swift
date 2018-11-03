//
//  ProjectorManagementTableViewController.swift
//  PMPSystem
//
//  Created by Oliver Lin on 24/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProjectorManagementTableViewController: UITableViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var myUser: MyUser?
    var projectorsList: [MyProjector] = []
    var imageURLList: [String] = []
    var imageArray: [UIImage] = []
    var sensor:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // user didn't loggin
        if Auth.auth().currentUser?.uid == nil{
            self.present(LoginViewController(), animated: true)
        }

        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor  = UIColor(red: 61, green: 91, blue: 151)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        handleProjectors()
        tableView.reloadData()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor  = UIColor(red: 61, green: 91, blue: 151);
        super.viewWillAppear(true)
        myUser = MyUser.onlyUser
        handleProjectors()
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectorsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectorsCollectionCell", for: indexPath) as! ProjectorManagementCollectionViewCell
        cell.projectorImage.image = UIImage(named: "whiteboard")
        cell.backgroundView = UIImageView(image: UIImage(named: "abstract"))
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        cell.projectAlias.text = projectorsList[indexPath.row].alias
        cell.projectBrand.text = projectorsList[indexPath.row].brand
        let urlString = self.imageURLList[indexPath.row]
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                // if download hits an error, so lets return out
                print(error)
                return
            }
            // if there is no error happens...
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // in half a second...
                cell.projectorImage.image = UIImage(data: data!)
            }
        }).resume()
        return cell
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
                self.imageURLList.removeAll()
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
                    self.sensor = (projectors["sensor"] as! String)
                    self.imageURLList.append(profileImageURL)
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
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "welcomeCell", for: indexPath) as! WelcomeCell
            cell.welcomeImage?.image = UIImage(named: "whiteboard")
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as! ProjectorsTableViewCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.reloadData()
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "funcCell", for: indexPath) 
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "func2Cell", for: indexPath)
            return cell
        }
        return WelcomeCell()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        }
        if indexPath.row == 1 {
            return 350
        }
        if indexPath.row == 2{
            return 75
        }
        if indexPath.row == 3{
            return 75
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mianStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = mianStoryboard.instantiateViewController(withIdentifier: "ProjectorInfoTableViewController") as! ProjectorInfoTableViewController
        destination.name = projectorsList[indexPath.row].alias
        destination.imgUrl = imageURLList[indexPath.row]
        destination.brand = projectorsList[indexPath.row].brand
        destination.proType = projectorsList[indexPath.row].type
        destination.light = projectorsList[indexPath.row].lampType
        destination.proLux = projectorsList[indexPath.row].maxLux
        destination.maxTemp = projectorsList[indexPath.row].maxTemp
        destination.minTemp = projectorsList[indexPath.row].minTemp
        destination.sensorNo = self.sensor
        self.navigationController?.pushViewController(destination, animated: true)
        
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

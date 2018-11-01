//
//  ProjectorsTableViewCell.swift
//  PMPSystem
//
//  Created by Oliver Lin on 24/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProjectorsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    var projectorsList: [MyProjector] = []
    var imageURLList: [String] = []
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectorsList.count
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
                    self.imageURLList.append(profileImageURL)
                   /* let url = URL(string: profileImageURL)
                    
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil {
                            // if download hits an error, so lets return out
                            print(error)
                            return
                        }
                        // if there is no error happens...
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // in half a second...
                            self.myUser?.identityImage = UIImage(data: data!)
                            let infoController = InfoViewController()
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                    }).resume()*/
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MM YYYY"
                    let formatedDate = dateFormatter.date(from: date)
                    self.projectorsList.append(MyProjector(alias: alias, brand: brand, date: formatedDate!, lampType: lampType, location: location, maxLux: doubleMaxLux!, maxTemp: doubleMaxTemp!, minTemp: doubleMinTemp!, power: 0, type: type))
                    
                }
                self.collectionView.reloadData()

            }
        })
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectorsCollectionCell", for: indexPath) as! ProjectorManagementCollectionViewCell
        cell.projectorImage.image = UIImage(named: "whiteboard")
        cell.backgroundView = UIImageView(image: UIImage(named: "abstract"))
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        cell.projectAlias.text = projectorsList[indexPath.row].alias
        cell.projectBrand.text = projectorsList[indexPath.row].brand
        return cell
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource = self
        collectionView.delegate = self
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  FindProjectorViewController.swift
//  PMPSystem
//
//  Created by Oliver Lin on 2/11/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class FindProjectorViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var projectorMapView: MKMapView!
    var projectorsList: [MyProjector] = []
    var imageURLList: [String] = []
    var projectorMapAnnotation: [ProjectorMapAnnotation] = []
    var voiceDatas: [VoiceData] = []
    var pairedProjectors: [MyProjector] = []
    var oneMinSensorDatas: [VoiceData] = []

    override func viewDidLoad() {
        projectorMapView.delegate = self
        super.viewDidLoad()
        handleProjectors()
        addADoneButton()
        observeInUseStatusChange()
        
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
                    let latitudeString = projectors["latitude"] as! String
                    let longitudeString = projectors["longitude"] as! String
                    let sensor = projectors["sensor"] as! String
                    
                    let latitude = Double(latitudeString)
                    let longitude = Double(longitudeString)
                    
                    //let latitude = Double(Util.removeStringQuotationMark(string: latitudeString))
                    //let longitude = Double(Util.removeStringQuotationMark(string: longitudeString))
                    
                    let profileImageURL = projectors["projectorProfileImageURL"] as? String ?? ""
                    self.imageURLList.append(profileImageURL)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MM YYYY"
                    let formatedDate = dateFormatter.date(from: date)
                    self.projectorsList.append(MyProjector(alias: alias, brand: brand, date: formatedDate!, lampType: lampType, location: location, maxLux: doubleMaxLux!, maxTemp: doubleMaxTemp!, minTemp: doubleMinTemp!, power: 0, type: type, longitude: longitude!, latitude: latitude!, sensor: sensor))
                    
                }
                self.addAnnotationsToList()
                self.addAnnotationToMap()
                print("123")
               
                
            }
        })
    }

    // this method add the data in projector's list to the map annotation list
    func addAnnotationsToList(){
        guard projectorsList != nil else {
            return
        }
        for projector in projectorsList {
            let location = ProjectorMapAnnotation(title: projector.alias!, subtitle: projector.brand!, lat: projector.latitude!, long: projector.longitude!, image: UIImage(named: "lamp_black")!)
            projectorMapAnnotation.append(location)
        }
    }
    
    // this method add the annotation list the the map
    func addAnnotationToMap(){
        guard projectorMapAnnotation != nil else {
            return
        }
        // have to make sure that there is at lease a value.
        if projectorMapAnnotation.count != 0 {
            // the map coordinate at the center of the map view.
            projectorMapView.centerCoordinate = projectorMapAnnotation[0].coordinate
            // change the current visible region and optionally animates the change and the amount of north-to-south west - to - east distance to use for the span, the distance (square) is 250 by 250 by default.
            projectorMapView.setRegion(MKCoordinateRegion(center: projectorMapAnnotation[0].coordinate, latitudinalMeters: 250, longitudinalMeters: 250), animated: true)
        }
        else {
            // the the default centre location to Monash Caulfield campus.
            projectorMapView.centerCoordinate = CLLocationCoordinate2D(latitude: -37.8770, longitude: 145.0443)
            projectorMapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.8770, longitude: 145.0443), latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
        }
        // set each annotation in the annolodation list to the map view
        for location in projectorMapAnnotation {
            projectorMapView.addAnnotation(location)
        }
        projectorMapView.reloadInputViews()
    }
    
    
    // Returns the view associated with the specified annotatino object
    // the annotations on the map will then show.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let anntationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
        let projectorAnnotation = annotation as! ProjectorMapAnnotation
        
        // set image on the annotation
        anntationView.image = Util.resizeImage(image: projectorAnnotation.image!, targetSize: CGSize(width: 30, height: 30))
        
        anntationView.leftCalloutAccessoryView = UIImageView(image: Util.resizeImage(image: projectorAnnotation.image!, targetSize: CGSize(width: 20, height: 20)))
        anntationView.rightCalloutAccessoryView = UIButton(type: .infoDark)
        anntationView.canShowCallout = true
        return anntationView
    }
    
    @objc func test(){
        
        projectorMapView.removeAnnotations(projectorMapAnnotation)
    }
    
    func addADoneButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "test", style: .done, target: self, action: #selector(test))
    }
    
    func observeInUseStatusChange(){
        //retrieve the data from firebase
        let refHandle = Database.database().reference(fromURL: "https://pmpsystem-f537e.firebaseio.com/")
        let voiceRef = refHandle.child("sensors").child("sensor1").child("voice")
        self.voiceDatas.removeAll()
        voiceRef.observe(.value) { (snapshot) in
            // get the number of the children
            print("childrenCount: \(snapshot.childrenCount)")
            if snapshot.childrenCount > 0 {
                self.voiceDatas.removeAll()
                for firebaseVoiceData in snapshot.children.allObjects as! [DataSnapshot] {
                    let pair = firebaseVoiceData.value as! [String: AnyObject]
                    let id = pair["date"] as! Int
                    let voice = pair["voice"] as! Int
                    self.voiceDatas.append(VoiceData(dateAndTime: id, voice: voice))
                }
            }
            
            // empty all observed values.
            self.pairedProjectors.removeAll()
            self.oneMinSensorDatas.removeAll()
            
            
            if self.voiceDatas.count >= 10 {
                for i in 0..<10 {
                    self.oneMinSensorDatas.append(self.voiceDatas[self.voiceDatas.count-i-1])
                    print(Util.convertUnixTimeToDate(timeIntervalSince1970: self.voiceDatas[i].dateAndTime))
                    print(self.voiceDatas[i].voice)
                }
            }
            
            for projector in self.projectorsList {
                if projector.sensor == "sensor1" {
                    self.pairedProjectors.append(projector)
                }
            }
            print("pairedProjectors: \(self.pairedProjectors.count)")
            
            var inUseDataCount = 0
            for oneMinSensorData in self.oneMinSensorDatas {
                if oneMinSensorData.voice > 15{
                    inUseDataCount += 1
                }
            }
            
            // the projector(s) is use
            if inUseDataCount > 0 {
                for annotation in self.projectorMapAnnotation{
                    for pairedProjector in self.pairedProjectors{
                        if annotation.title == pairedProjector.alias {
                            print("yes, find one!")
                            self.projectorMapView.removeAnnotation(annotation)
                            annotation.image = UIImage(named: "lamp_colour")
                            self.projectorMapView.addAnnotation(annotation)
                        }
                    }
                }
            }
            
            // the projector(s) is not use
            if inUseDataCount == 0 {
                for annotation in self.projectorMapAnnotation{
                    for pairedProjector in self.pairedProjectors{
                        if annotation.title == pairedProjector.alias {
                            print("yes, find one!")
                            self.projectorMapView.removeAnnotation(annotation)
                            annotation.image = UIImage(named: "lamp_black")
                            self.projectorMapView.addAnnotation(annotation)
                        }
                    }
                }
            }

            self.projectorMapView.reloadInputViews()
        }
        
        
        
        

    }
    
}

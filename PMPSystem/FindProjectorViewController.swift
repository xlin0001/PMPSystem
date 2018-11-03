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

    override func viewDidLoad() {
        projectorMapView.delegate = self
        super.viewDidLoad()
        handleProjectors()
        
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
                    
                    let latitude = Double(latitudeString)
                    let longitude = Double(longitudeString)
                    
                    //let latitude = Double(Util.removeStringQuotationMark(string: latitudeString))
                    //let longitude = Double(Util.removeStringQuotationMark(string: longitudeString))
                    
                    let profileImageURL = projectors["projectorProfileImageURL"] as? String ?? ""
                    self.imageURLList.append(profileImageURL)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MM YYYY"
                    let formatedDate = dateFormatter.date(from: date)
                    self.projectorsList.append(MyProjector(alias: alias, brand: brand, date: formatedDate!, lampType: lampType, location: location, maxLux: doubleMaxLux!, maxTemp: doubleMaxTemp!, minTemp: doubleMinTemp!, power: 0, type: type, longitude: longitude!, latitude: latitude!))
                    
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
            let location = ProjectorMapAnnotation(title: projector.alias!, subtitle: projector.brand!, lat: projector.latitude!, long: projector.longitude!, image: UIImage(named: "projector")!)
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
        anntationView.image = Util.resizeImage(image: projectorAnnotation.image!, targetSize: CGSize(width: 20, height: 20))
        
        anntationView.leftCalloutAccessoryView = UIImageView(image: Util.resizeImage(image: projectorAnnotation.image!, targetSize: CGSize(width: 20, height: 20)))
        anntationView.rightCalloutAccessoryView = UIButton(type: .infoDark)
        anntationView.canShowCallout = true
        return anntationView
    }
    
}
